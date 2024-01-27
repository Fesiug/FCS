AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName = "Clothing"
ENT.Category = "Gutting"
ENT.Spawnable = false

function ENT:Initialize()
	self:AddEffects( EF_BONEMERGE )
	self:AddEFlags( EFL_KEEP_ON_RECREATE_ENTITIES )
end

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "ID")
end

function ENT:GetItemTable()
	return FCS.GetItem( self:GetID() )
end

function ENT:Think()
	if SERVER then
		if self:GetParent() == NULL then
			print( "Parent is gone. Removing self.", self, self:GetID() )
			self:Remove()
			return
		end
		local ply = self:GetParent()
		self:DrawShadow( !ply:GetRagdollEntity():IsValid() )
	end
end

if CLIENT then
	local v1 = Vector(1,1,1)
	FCS_CSModelTable = FCS_CSModelTable or {}
	function ENT:Draw()
		local bm = self:GetItemTable().BoneMods
		local restoretable
		if bm then
			restoretable = {}
			for k, v in pairs( bm ) do
				if self:GetParent():FCSGetFlags()[k] then
					for BoneName, BoneTask in pairs( v ) do
						local BoneID = self:LookupBone( BoneName )
						if !BoneID then continue end
						local Matri = self:GetBoneMatrix( BoneID )
						if !Matri then continue end
						restoretable[BoneID] = Matrix( Matri )
						if BoneTask.scale then
							Matri:Scale( BoneTask.scale )
						end
						if BoneTask.translate then
							Matri:Translate( BoneTask.translate )
						end
						if BoneTask.rotate then
							Matri:Rotate( BoneTask.rotate )
						end
						self:SetBoneMatrix( BoneID, Matri )
					end
				end
			end
		end
		local ply = self:GetParent()
		if ply:GetRagdollEntity():IsValid() then
			if !IsValid( self.FakeClothes ) then
				self.FakeClothes = ClientsideModel( self:GetModel() )
				FCS_CSModelTable[self.FakeClothes] = true
				self.FakeClothes.RGE = ply:GetRagdollEntity()
				self.FakeClothes:AddEffects( EF_BONEMERGE )
				self.FakeClothes:SetParent( ply:GetRagdollEntity() )
				self.FakeClothes:Spawn()
				self.FakeClothes:CreateShadow()
				return
			end
		else
			if IsValid( self.FakeClothes ) then
				self.FakeClothes:DestroyShadow()
				self.FakeClothes:Remove()
			end
			self:DrawModel()
			if restoretable then
				for i, v in pairs( restoretable ) do
					self:SetBoneMatrix( i, v )
				end
			end
		end
	end

	function ENT:OnRemove()
		if IsValid( self.FakeClothes ) then
			self.FakeClothes:DestroyShadow()
			self.FakeClothes:Remove()
		end
	end
	
	hook.Add("Think", "FCS_Think_CSRagdoll", function()
		for i, v in pairs( FCS_CSModelTable ) do
			if !i:IsValid() then
				FCS_CSModelTable[i] = nil
				continue
			end

			if !i.RGE:IsValid() then i:Remove() end
		end
	end)
end