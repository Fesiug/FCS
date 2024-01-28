AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName = "Item Pickup Base"
ENT.Category = "Gutting - Items"
ENT.Spawnable = false
ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Initialize()
	self:SetModel("models/props_c17/SuitCase001a.mdl")
	if SERVER then
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
		self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
		self:GetPhysicsObject():Wake()
		self.SpawnTime = CurTime()
	end
end

local timeee
if SERVER then
	timeee = CreateConVar("fcs_item_despawntime", 0, FCVAR_ARCHIVE, nil, 0)
end

function ENT:Think()
	if SERVER then
		local time = timeee:GetInt()
		if time > 0 and (self.SpawnTime+time) <= CurTime() then
			self:Remove()
			return
		end
	end
end

function ENT:Use( ent )
	local ID = self.ItemToGive
	ent:FCSEquip( ID )
	self:EmitSound( "items/ammopickup.wav", 70, 100, 1 )
	self:Remove()
end

function ENT:GetPreferredCarryAngles()
	return Angle( 0, 90, 0 )
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end

	surface.CreateFont("FCS_Item",{
		font = "Trebuchet MS Bold",
		size = 4/0.1
	})

	surface.CreateFont("FCS_Item2",{
		font = "Trebuchet MS Bold",
		size = 2/0.1
	})

	function ENT:DrawTranslucent()
		local angle = self:GetAngles()
		
		angle.r = angle.r + 90
		surface.SetFont("FCS_Item")
		local text = FCS.GetItem(self.ItemToGive).PrintName
		local tobig = false
		if surface.GetTextSize(text) > (32/0.1) then
			tobig = true
		end
		for i=1, 2 do
			if i==2 then
				angle:RotateAroundAxis( angle:Right(), 180 )
			end
			local pos = self:GetPos()
			pos:Add( angle:Up() * 6.2 )
			pos:Add( angle:Right() * (tobig and 0 or -1) )
			cam.Start3D2D( pos, angle, 0.1 )
				draw.SimpleText( text, (tobig and "FCS_Item2" or "FCS_Item"), 0, 0, color_white, TEXT_ALIGN_CENTER )
			cam.End3D2D()
		end
	end
end