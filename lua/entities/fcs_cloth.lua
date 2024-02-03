AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName = "Clothing"
ENT.Category = "Gutting"
ENT.Spawnable = false

function ENT:Initialize()
	self:AddEffects( EF_BONEMERGE )
	self:AddEffects( EF_BONEMERGE_FASTCULL )
	self:AddEFlags( EFL_KEEP_ON_RECREATE_ENTITIES )
end

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "ID")
	self:NetworkVar("Entity", 0, "FCSOwner")
end

function ENT:GetItemTable()
	return FCS.GetItem( self:GetID() )
end

function ENT:Think()
	if SERVER then
		if self:GetFCSOwner() == NULL then
			print( "Parent is gone. Removing self.", self, self:GetID() )
			self:Remove()
			return
		end
		local ply = self:GetFCSOwner()
		self:DrawShadow( !ply:GetRagdollEntity():IsValid() )
	end
end

if CLIENT then
	
	local function LetsBoneMod( self, flags )
		local bm = self:GetItemTable().BoneMods
		if bm then
			for k, v in pairs( bm ) do
				if flags[k] then
					for BoneName, BoneTask in pairs( v ) do
						local BoneID = self:LookupBone( BoneName )
						if !BoneID then continue end
						local Matri = self:GetBoneMatrix( BoneID )
						if !Matri then continue end
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
	end

	local v1 = Vector(1,1,1)
	FCS_CSModelTable = FCS_CSModelTable or {}
	function ENT:Draw()
		local ply = self:GetFCSOwner()
		if ply:IsValid() then
			local item = self:GetItemTable()
			-- Keep setting this in case of emergency
			self:SetParent( ply )

			-- Do bone modifications
			self:SetupBones()
			LetsBoneMod( self, ply:FCSGetFlags() )

			local rge = ply:GetRagdollEntity()
			local SUPERDEATH = ply:GetNW2Entity("SUPERDEATH", NULL)
			if SUPERDEATH:IsValid() then
				rge = SUPERDEATH
			end
			if rge:IsValid() then
				if !IsValid( self.FakeClothes ) then
					self.FakeClothes = ClientsideModel( self:GetModel() )
					FCS_CSModelTable[self.FakeClothes] = true
					self.FakeClothes.RGE = rge
					self.FakeClothes.God = ply
					self.FakeClothes:AddEffects( EF_BONEMERGE )
					self.FakeClothes:SetSkin( self:GetSkin() )
					self.FakeClothes:AddEffects( EF_BONEMERGE_FASTCULL )
					self.FakeClothes:SetParent( rge )

					if item.Bodygroups then
						for k, v in pairs(item.Bodygroups) do
							-- print(k, v)
							self.FakeClothes:SetBodygroup(k, v)
						end
					end

					self.FakeClothes:Spawn()
					--self.FakeClothes:CreateShadow()
				end
			else
				if IsValid( self.FakeClothes ) then
					--self.FakeClothes:DestroyShadow()
					self.FakeClothes:Remove()
				end
			end
			if ply:Alive() then
				self:DrawModel()
			else
				return
			end
		else
			print( ply, " is INVALID. What the fuck?!" )
		end
	end

	function ENT:OnRemove()
		if IsValid( self.FakeClothes ) then
			--self.FakeClothes:DestroyShadow()
			self.FakeClothes:Remove()
		end
	end

	local debugg = CreateClientConVar( "fcs_debug_csmdl", 0, false, false )

	local function dp( self, ... )
		if debugg:GetBool() then
			print( "[FCS] [CSMDL]", ... )
		end
	end
	
	hook.Add("Think", "FCS_Think_CSRagdoll", function()
		for i, v in pairs( FCS_CSModelTable ) do
			if !i:IsValid() then
				FCS_CSModelTable[i] = nil
				continue
			else
				if i:GetParent() == NULL then
					if i.RGE:IsValid() then
						i:SetParent( i.RGE )
						dp( i, "Didn't have a parent before, have one now", i.RGE )
					else
						dp( i, "First check: I have no parent anymore and this is a disaster." )
					end
				end
				if !i.RGE:IsValid() then
					-- Get a new one
					local rge = i.God:GetRagdollEntity()
					local SUPERDEATH = i.God:GetNW2Entity("SUPERDEATH", NULL)
					if SUPERDEATH:IsValid() then
						rge = SUPERDEATH
					end
					if rge:IsValid() then
						dp( i, "Got a new one ", rge )
						i.RGE = rge
						if i:GetParent() == NULL then
							i:SetParent( i, i.RGE )
							print( "Got a new parent", i:GetParent() )
						end
					else
						dp( i, "Fail.. Remove" )
						i:Remove()
					end

				end
			end

		end
	end)
end