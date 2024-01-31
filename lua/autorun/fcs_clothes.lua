
player_manager.AddValidModel( "STRP Male 01",					"models/fgut/male_01_01.mdl" )
player_manager.AddValidModel( "STRP Male 02",					"models/fgut/male_02_01.mdl" )
player_manager.AddValidModel( "STRP Male 03",					"models/fgut/male_03_01.mdl" )
player_manager.AddValidModel( "STRP Male 04",					"models/fgut/male_04_01.mdl" )
player_manager.AddValidModel( "STRP Male 05",					"models/fgut/male_05_01.mdl" )
player_manager.AddValidModel( "STRP Male 06",					"models/fgut/male_06_01.mdl" )
player_manager.AddValidModel( "STRP Male 07",					"models/fgut/male_07_01.mdl" )
player_manager.AddValidModel( "STRP Male 08",					"models/fgut/male_08_01.mdl" )
player_manager.AddValidModel( "STRP Male 09",					"models/fgut/male_09_01.mdl" )

player_manager.AddValidHands( "STRP Male 01",					"models/fgut/chands_02.mdl", 0, "00000000" )
player_manager.AddValidHands( "STRP Male 02",					"models/fgut/chands_02.mdl", 0, "00000000" )
player_manager.AddValidHands( "STRP Male 03",					"models/fgut/chands_02.mdl", 0, "00000000" )
player_manager.AddValidHands( "STRP Male 04",					"models/fgut/chands_02.mdl", 0, "00000000" )
player_manager.AddValidHands( "STRP Male 05",					"models/fgut/chands_02.mdl", 0, "00000000" )
player_manager.AddValidHands( "STRP Male 06",					"models/fgut/chands_02.mdl", 0, "00000000" )
player_manager.AddValidHands( "STRP Male 07",					"models/fgut/chands_02.mdl", 0, "00000000" )
player_manager.AddValidHands( "STRP Male 08",					"models/fgut/chands_02.mdl", 0, "00000000" )
player_manager.AddValidHands( "STRP Male 09",					"models/fgut/chands_02.mdl", 0, "00000000" )

player_manager.AddValidModel( "STRP Female 01",					"models/fgut/female_01_01.mdl" )
player_manager.AddValidModel( "STRP Female 02",					"models/fgut/female_02_01.mdl" )
player_manager.AddValidModel( "STRP Female 03",					"models/fgut/female_03_01.mdl" )
player_manager.AddValidModel( "STRP Female 04",					"models/fgut/female_04_01.mdl" )
player_manager.AddValidModel( "STRP Female 06",					"models/fgut/female_06_01.mdl" )
player_manager.AddValidModel( "STRP Female 07",					"models/fgut/female_07_01.mdl" )

player_manager.AddValidHands( "STRP Female 01",					"models/fgut/chands_02.mdl", 0, "00000000" )
player_manager.AddValidHands( "STRP Female 02",					"models/fgut/chands_02.mdl", 0, "00000000" )
player_manager.AddValidHands( "STRP Female 03",					"models/fgut/chands_02.mdl", 0, "00000000" )
player_manager.AddValidHands( "STRP Female 04",					"models/fgut/chands_02.mdl", 0, "00000000" )
player_manager.AddValidHands( "STRP Female 06",					"models/fgut/chands_02.mdl", 0, "00000000" )
player_manager.AddValidHands( "STRP Female 07",					"models/fgut/chands_02.mdl", 0, "00000000" )

FCS = {}

-- Upper Body
FCS_SHIRT	= 1
FCS_EXO		= 2 -- body armor etc.
FCS_GLOVES	= 4

-- Lower Body
FCS_PANTS	= 8
FCS_BELT	= 16 -- also used for chest rigs
FCS_SHOES	= 32

-- Head
FCS_HAT		= 64 -- top of head
FCS_EYES	= 128
FCS_MOUTH	= 256
FCS_EARS	= 512

FCS_LAST_SLOT = 512

FCS.TL = {
	-- Upper Body
	FCS_SHIRT,
	FCS_EXO,
	FCS_GLOVES,

	-- Lower Body
	FCS_PANTS,
	FCS_BELT,
	FCS_SHOES,

	-- Head
	FCS_HAT,
	FCS_EYES,
	FCS_MOUTH,
	FCS_EARS,
}

FCS.TTS = {
	[FCS_SHIRT]		= "Shirt",
	[FCS_EXO]		= "Exo",
	[FCS_GLOVES]	= "Gloves",

	[FCS_PANTS]		= "Pants",
	[FCS_BELT]		= "Belt",
	[FCS_SHOES]		= "Shoes",

	[FCS_HAT]		= "Hat",
	[FCS_EYES]		= "Eyes",
	[FCS_MOUTH]		= "Mouth",
	[FCS_EARS]		= "Ears",
}

function FCS.SlotToList(b)
	local slots = {}
	local i = 1
	while b > 0 do
		if b % 2 == 1 then
			table.insert(slots, i)
		end
		b = bit.rshift(b, 1)
		i = i + 1
	end
	return slots
end

function FCS.SlotToName(i)
	return FCS.TTS[FCS.TL[i]]
end

if SERVER then
for i, v in ipairs( FCS.TL ) do
	concommand.Add("fcs_drop_" .. FCS.TTS[v]:lower(), function( ply, cmd )
		if CLIENT then print("[FCS] You can't call this on the CLIENT realm.") debug.Trace() return end
		if v == FCS_SHIRT or v == FCS_PANTS then return end
		ply:FCSRemoveSlot( v )
	end)
end

concommand.Add("fcs_give_item", function( ply, cmd, args )
	if CLIENT then print("[FCS] You can't call this on the CLIENT realm.") debug.Trace() return end
	if not ply:IsAdmin() then return end
	local ent = ply:GetEyeTrace().Entity
	if not IsValid(ent) then return end
	local swag = args[1]
	if not FCS.Items[swag] then return end
	ent:FCSEquip(swag, true)
end)

end

FCS.Items = {}

function FCS.GetItem( ID )
	return FCS.Items[ ID ]
end

function FCS.DefineItem( ID, Table )
	FCS.Items[ID] = Table

	do
		local tent = {}
		tent.Base = "fcs_item"
		tent.IconOverride = "materials/fcs/items/" .. ID .. ".png"
		tent.PrintName = Table.PrintName or ID
		tent.Spawnable = true
		tent.AdminOnly = false
		tent.ItemToGive = ID
		tent.Category = "FCS - " .. (Table.Category or FCS.TTS[Table.Type])

		scripted_ents.Register( tent, "fcs_item_" .. ID )
	end
end

if SERVER then
	util.AddNetworkString("FCS_Equip")
	util.AddNetworkString("FCS_Option")

	net.Receive("FCS_Option", function(len, ply)
		local ID = net.ReadString()
		local item = FCS.Items[ID]
		if not item then return end
		local ent = ply:FCSGetSlotEntity(item.Type)
		if not IsValid(ent) or ent:GetID() ~= ID then return end

		if item.Options.Skins then
			local sk = net.ReadUInt(6)
			if item.Options.Skins[sk] then
				ent:SetSkin(sk)
			end
		end
		if item.Options.Bodygroups then
			local bg = net.ReadUInt(6)
			if item.Options.Bodygroups[bg] then
				-- TODO
			end
		end
		if item.Options.Color then
			ent:SetColor(net.ReadColor())
		end
	end)
else
	net.Receive("FCS_Equip", function()
		local ID = net.ReadString()
		local ITEM = FCS.GetItem(ID)
		chat.AddText( color_white, "Enjoy the " .. ITEM.PrintName .. "." )
	end)

	net.Receive("FCS_Option", function()
		FCS.CreateClothOptionMenu(net.ReadString())
	end)
end

local PT = FindMetaTable("Player")

function PT:FCSEvaluateNaked()
	self:SetBodygroup( 1, self:FCSSlotOccupied( FCS_SHIRT ) and 1 or 0 )
	self:SetBodygroup( 2, self:FCSSlotOccupied( FCS_PANTS )  and 1 or 0 )
end

function PT:FCSEvaluateFlags()
	local flags = ""
	local checked = {}
	for i, slot in ipairs(FCS.TL) do
		local nw2 = "FCS_" .. FCS.TTS[slot]
		local ent = self:GetNW2Entity(nw2, NULL)
		if IsValid(ent) and not checked[ent] then
			local ID = ent:GetID()
			local TABLE = FCS.GetItem(ID)

			if TABLE.Flags then
				for _, v in ipairs(TABLE.Flags) do
					flags = flags .. v .. ","
				end
			end
			checked[ent] = true
		end
	end

	if self:GetModel():find("female") then
		flags = flags .. "female,"
	end

	if self:GetModel():find("female_01") then
		flags = flags .. "female_01,"
	elseif self:GetModel():find("female_02") then
		flags = flags .. "female_02,"
	elseif self:GetModel():find("female_03") then
		flags = flags .. "female_03,"
	elseif self:GetModel():find("female_04") then
		flags = flags .. "female_04,"
	elseif self:GetModel():find("female_06") then
		flags = flags .. "female_06,"
	elseif self:GetModel():find("female_07") then
		flags = flags .. "female_07,"
	elseif self:GetModel():find("male_01") then
		flags = flags .. "male_01,"
	elseif self:GetModel():find("male_02") then
		flags = flags .. "male_02,"
	elseif self:GetModel():find("male_03") then
		flags = flags .. "male_03,"
	elseif self:GetModel():find("male_04") then
		flags = flags .. "male_04,"
	elseif self:GetModel():find("male_05") then
		flags = flags .. "male_05,"
	elseif self:GetModel():find("male_06") then
		flags = flags .. "male_06,"
	elseif self:GetModel():find("male_07") then
		flags = flags .. "male_07,"
	elseif self:GetModel():find("male_08") then
		flags = flags .. "male_08,"
	elseif self:GetModel():find("male_09") then
		flags = flags .. "male_09,"
	end

	flags = flags:Left(-2)
	self:SetNW2String("FCS_Flags", flags)
end

function PT:FCSGetFlags()
	local flags = self:GetNW2String("FCS_Flags", "")
	if flags == self.cache_flagkey and self.cache_flagst then
		return self.cache_flagst
	end
	local flags_e = string.Explode(",", flags)

	local flagst = { [true] = true }
	for i, v in ipairs( flags_e ) do
		flagst[v] = true
	end

	self.cache_flagkey = flags
	self.cache_flagst = flagst

	return flagst
end

function PT:FCSGetArmorAreas(hitgroup)
	for i, slot in ipairs(FCS.TL) do
		local nw2 = "FCS_" .. FCS.TTS[slot]
		local ent = self:GetNW2Entity(nw2, NULL)
		if IsValid(ent) then
			local ID = ent:GetID()
			local TABLE = FCS.GetItem(ID)

			if TABLE.Armor and TABLE.Armor.Region[hitgroup] then
				return ent, TABLE.Armor.Region[hitgroup]
			end
		end
	end
end

function PT:FCSEquip( ID, DontDrop )
	local ITEM = FCS.GetItem(ID)
	if !ITEM then print("Invalid item", ID) return false end

	self:FCSRemoveSlot(ITEM.Type, DontDrop)

	local Fuck = ents.Create("fcs_cloth")
	Fuck:SetID( ID )
	Fuck:SetModel( ITEM.Model )
	Fuck:SetParent(self)
	Fuck:SetFCSOwner(self)
	Fuck:SetSkin( ITEM.Skin or 0 )

	if ITEM.Bodygroups then
		for k, v in pairs(ITEM.Bodygroups) do
			Fuck:SetBodygroup(k, v)
		end
	end

	Fuck:Spawn()

	local slots = FCS.SlotToList(ITEM.Type)
	for _, v in pairs(slots) do
		self:SetNW2Entity("FCS_" .. FCS.SlotToName(v), Fuck)
	end

	net.Start("FCS_Equip")
		net.WriteString(ID)
	net.Send(self)

	self:FCSEvaluateNaked()
	self:FCSEvaluateFlags()
	return true
end

function PT:FCSGetSlotEntity( Slot )
	local slots = FCS.SlotToList(Slot)
	for _, v in pairs(slots) do
		local ent = self:GetNW2Entity("FCS_" .. FCS.SlotToName(v))
		if IsValid(ent) then
			return ent
		end
	end
end

function PT:FCSSlotOccupied( Slot )
	local slots = FCS.SlotToList(Slot)
	for _, v in pairs(slots) do
		if IsValid(self:GetNW2Entity("FCS_" .. FCS.SlotToName(v))) then
			return true
		end
	end
end

function PT:FCSRemoveSlot( Slot, DontDrop )
	local slots = FCS.SlotToList(Slot)
	for _, v in pairs(slots) do
		local nw2 = "FCS_" .. FCS.SlotToName(v)
		local prevshirt = self:GetNW2Entity(nw2)
		if IsValid(prevshirt) then
			if !DontDrop then
				local drop = ents.Create( "fcs_item_" .. prevshirt:GetID() )
				drop:SetPos( self:EyePos() + self:EyeAngles():Up() * -8 )
				drop:SetVelocity( self:EyeAngles():Forward() * 100 )
				drop:Spawn()
			end
			prevshirt:Remove()
			self:SetNW2Entity(nw2, NULL)
		end
	end

	self:FCSEvaluateNaked()
	self:FCSEvaluateFlags()
	return true
end

hook.Add( "PlayerSpawn", "FCS_PlayerSpawn", function( ply )
	if ply:IsBot() then
		timer.Simple( 0, function()
			if math.random(1, 2) == 1 then
				ply:SetModel( "models/fgut/male_0" .. math.random( 1, 9 ) .. "_01.mdl" )
			else
				local super = math.random( 1, 6 )
				if super == 5 then super = 7 end
				ply:SetModel( "models/fgut/female_0" .. super .. "_01.mdl" )
			end
			ply:SetSkin( math.random( 1, ply:SkinCount()-1 ) )
			ply:SetBodyGroups( "00000000000000000" )
		end)
	end
end)
hook.Add( "PlayerSetModel", "FCS_PlayerSetModel", function( ply )
	timer.Simple( 0.1, function()
		if ply:GetModel():Left(#"models/fgut") == "models/fgut" then
			--for i, v in FCS.TL
			if !ply:FCSSlotOccupied( FCS_SHIRT ) then
				ply:FCSEquip( "s_citizen1", true )
			end
			if !ply:FCSSlotOccupied( FCS_PANTS ) then
				ply:FCSEquip( "p_citizen1", true )
			end
			ply:FCSEvaluateNaked()
			ply:FCSEvaluateFlags()
			ply:SetNW2Int( "FCS_EyeColor", GetConVar("fcs_eyecolor"):GetInt() )
		else
			for i, v in ipairs( FCS.TL ) do
				ply:FCSRemoveSlot( v )
			end
		end
	end)
end )

if SERVER then
	hook.Add("PlayerPostThink", "FCS_PlayerPostThink", function( ply )
		if !ply.LastModel then
			ply.LastModel = ply:GetModel()
		end

		if ply.LastModel != ply:GetModel() then
			print("[FCS] Model changed, reevaluating", ply, ply:GetModel())
			ply.LastModel = ply:GetModel()
			ply:FCSEvaluateFlags()
			ply:FCSEvaluateNaked()
		end
	end)
end

do
	local function qv( scale )
		return Vector( scale, scale, scale )
	end
	local v = Vector
	local a = Angle
	local OVERALLSPATCH = {
		["ValveBiped.Bip01_Pelvis"] = {
			scale = Vector( 0.9, 0.9, 0.9 ),
			translate = Vector( 0, 0, 1 ),
		},
	}
	local GENERICFIX = {
		["overalls"] = OVERALLSPATCH,
		["female"] = {
			["ValveBiped.Bip01_Spine4"] = {
				scale = qv( 1 ),
				translate = v( -2, -0.2, 0 ),
			},
			["ValveBiped.Bip01_Neck1"] = {
				scale = qv( 0.8 ),
				translate = v( -1, 0.2, 0 ),
			},
			["ValveBiped.Bip01_Head1"] = {
				scale = qv( 0.8 ),
				translate = v( -1, 0.2, 0 ),
			},
			["ValveBiped.Bip01_Spine2"] = {
				scale = v( 0.8, 0.9, 0.8 ),
				translate = v( -1, 1, 0 ),
			},
			["ValveBiped.Bip01_Spine1"] = {
				scale = qv( 0.8 ),
				--translate = v( 0, 0, 0 ),
			},
			["ValveBiped.Bip01_Spine"] = {
				scale = qv( 0.8 ),
				--translate = v( 0, 0, 0 ),
			},
			["ValveBiped.Bip01_Pelvis"] = {
				scale = qv( 0.9 ),
				translate = v( 0, 0, -0.5 ),
			},
			-- Arms are weird
			["ValveBiped.Bip01_L_Forearm"] = {
				rotate = a( -5, 5, 0 ),
			},
			["ValveBiped.Bip01_R_Forearm"] = {
				rotate = a( 5, 5, 0 ),
			},
			["ValveBiped.Bip01_L_Clavicle"] = {
				scale = qv( 0.9 ),
			},
			["ValveBiped.Bip01_R_Clavicle"] = {
				scale = qv( 0.9 ),
			},
			--["ValveBiped.Bip01_L_UpperArm"] = {
			--	scale = qv( 1.0 ),
			--},
			--["ValveBiped.Bip01_R_UpperArm"] = {
			--	scale = qv( 1.0 ),
			--},
		},
	}
	-- Shirts
	FCS.DefineItem("s_citizen1", {
		PrintName = "Denim Jacket",
		Type = FCS_SHIRT,
		BoneMods = GENERICFIX,
		Model = "models/fgut/shirt_01_03.mdl",
	})

	FCS.DefineItem("s_citizen2", {
		PrintName = "Faded Longsleeve",
		Type = FCS_SHIRT,
		BoneMods = GENERICFIX,
		Model = "models/fgut/shirt_03_01.mdl",
	})

	FCS.DefineItem("s_cmb1", {
		PrintName = "CWU - Orange Division",
		Type = FCS_SHIRT,
		BoneMods = GENERICFIX,
		Model = "models/fgut/shirt_cmb01_02.mdl",
	})

	FCS.DefineItem("s_cmb2", {
		PrintName = "CWU - Yellow Division",
		Type = FCS_SHIRT,
		BoneMods = GENERICFIX,
		Model = "models/fgut/shirt_cmb02_01.mdl",
	})

	FCS.DefineItem("s_cmb3", {
		PrintName = "CWU - Blue Division",
		Type = FCS_SHIRT,
		BoneMods = GENERICFIX,
		Model = "models/fgut/shirt_cmb03_01.mdl",
	})

	FCS.DefineItem("s_rebel1", {
		PrintName = "Rebel (Blue)",
		Type = FCS_SHIRT,
		Flags = {
			"rebel",
		},
		BoneMods = GENERICFIX,
		Model = "models/fgut/shirt_rebel01_01.mdl",
	})

	FCS.DefineItem("s_rebel2", {
		PrintName = "Rebel (Green)",
		Type = FCS_SHIRT,
		Flags = {
			"rebel",
		},
		BoneMods = GENERICFIX,
		Model = "models/fgut/shirt_rebel02_01.mdl",
	})

	FCS.DefineItem("s_refugee1", {
		PrintName = "Pale Tan Shirt",
		Type = FCS_SHIRT,
		BoneMods = GENERICFIX,
		Model = "models/fgut/shirt_refugee01_01.mdl",
	})

	FCS.DefineItem("s_refugee2", {
		PrintName = "Olive Green Shirt",
		Type = FCS_SHIRT,
		BoneMods = GENERICFIX,
		Model = "models/fgut/shirt_refugee02_01.mdl",
	})

	FCS.DefineItem("s_hostage1", {
		PrintName = "DSB (Blue)",
		Type = FCS_SHIRT,
		BoneMods = GENERICFIX,
		Model = "models/fgut/shirt_hostage01_01.mdl",
	})

	FCS.DefineItem("s_hostage2", {
		PrintName = "DSB (White)",
		Type = FCS_SHIRT,
		BoneMods = GENERICFIX,
		Model = "models/fgut/shirt_hostage02_01.mdl",
	})

	FCS.DefineItem("s_medic1", {
		PrintName = "Medic Armed (White)",
		Type = FCS_SHIRT,
		BoneMods = GENERICFIX,
		Model = "models/fgut/shirt_medic01_01.mdl",
	})

	FCS.DefineItem("s_medic2", {
		PrintName = "Medic Armed (Blue)",
		Type = FCS_SHIRT,
		BoneMods = GENERICFIX,
		Model = "models/fgut/shirt_medic02_01.mdl",
	})

	FCS.DefineItem("s_medic3", {
		PrintName = "Medic",
		Type = FCS_SHIRT,
		BoneMods = GENERICFIX,
		Model = "models/fgut/shirt_medic03_01.mdl",
	})

	FCS.DefineItem("s_sec", {
		PrintName = "Security Shirt",
		Type = FCS_SHIRT,
		BoneMods = GENERICFIX,
		Model = "models/fgut/shirt_sec_18.mdl",
	})

	FCS.DefineItem("s_blacksuit", {
		PrintName = "Suit Top (Black)",
		Type = FCS_SHIRT,
		BoneMods = GENERICFIX,
		Model = "models/fgut/hl2rp/blacksuit_shirt_02.mdl",
	})

	FCS.DefineItem("s_admin", {
		PrintName = "Suit Top (Brown)",
		Type = FCS_SHIRT,
		BoneMods = GENERICFIX,
		Model = "models/fgut/hl2rp/admin_shirt_01.mdl",
	})

	FCS.DefineItem("s_security", {
		PrintName = "Security Jacket",
		Type = FCS_SHIRT,
		BoneMods = GENERICFIX,
		Model = "models/fgut/hl2rp/security_shirt_01.mdl",
	})

	FCS.DefineItem("s_security_bomber", {
		PrintName = "Bomber Jacket",
		Type = FCS_SHIRT,
		BoneMods = GENERICFIX,
		Model = "models/fgut/hl2rp/bomber_jacket_01.mdl",
	})

	FCS.DefineItem("s_surplus", {
		PrintName = "Surplus Jacket",
		Type = FCS_SHIRT,
		BoneMods = GENERICFIX,
		Model = "models/fgut/hl2rp/surplus_jacket_01.mdl",
	})




	-- Pants
	FCS.DefineItem("p_citizen1", {
		PrintName = "Blue Jeans",
		Type = FCS_PANTS,
		Model = "models/fgut/pants_01_04.mdl",
	})

	FCS.DefineItem("p_citizen2", {
		PrintName = "Gray Jeans",
		Type = FCS_PANTS,
		Model = "models/fgut/pants_02_01.mdl",
	})

	FCS.DefineItem("p_rebel1", {
		PrintName = "Plated Jeans",
		Type = FCS_PANTS,
		Model = "models/fgut/pants_rebel01_01.mdl",
	})

	FCS.DefineItem("p_rebel2", {
		PrintName = "Plated Dark Jeans",
		Type = FCS_PANTS,
		Model = "models/fgut/pants_rebel02_01.mdl",
	})

	FCS.DefineItem("p_sec", {
		PrintName = "Security Pants",
		Type = FCS_PANTS,
		BoneMods = GENERICFIX,
		Model = "models/fgut/pants_sec_02.mdl",
	})

	local su0 = 1.0
	local su1 = 1.08
	local su2 = 1.2
	local su4 = 1.2
	local sup = 1.0
	FCS.DefineItem("p_overalls1", {
		PrintName = "Overalls (Blue)",
		Type = FCS_PANTS,
		Flags = {
			"overalls",
		},
		Model = "models/fgut/pants_overalls_06.mdl",
	})

	FCS.DefineItem("p_overalls2", {
		PrintName = "Overalls (Black)",
		Type = FCS_PANTS,
		Flags = {
			"overalls",
		},
		Model = "models/fgut/pants_overalls_06.mdl",
		Skin = 1,
	})

	FCS.DefineItem("p_medic", {
		PrintName = "Tan Jeans",
		Type = FCS_PANTS,
		--BoneMods = {
			--["female"] = {
			--	["ValveBiped.Bip01_Pelvis"] = {
			--		scale = qv( 1.0 ),
			--		translate = v( 0, 1, 0 )
			--	},
			--},
		--},
		Model = "models/fgut/pants_medic_01.mdl",
	})

	local ELIPANTS = {
		[true] = {
			["ValveBiped.Bip01_Pelvis"] = {
				translate = Vector( 0, -2, 0 ),
			},
			["ValveBiped.Bip01_L_Thigh"] = {
				translate = Vector( 2/2, 0, 0 ),
			},
			["ValveBiped.Bip01_R_Thigh"] = {
				translate = Vector( 2/2, 0, 0 ),
			},
		},
	},
	FCS.DefineItem("p_eli", {
		PrintName = "Cargo Pants",
		Type = FCS_PANTS,
		BoneMods = ELIPANTS,
		Model = "models/fgut/pants_eli_10.mdl",
	})
	FCS.DefineItem("p_eli2", {
		PrintName = "Cargo Pants (Green)",
		Type = FCS_PANTS,
		BoneMods = ELIPANTS,
		Model = "models/fgut/pants_eli_10.mdl",
		Skin = 1,
	})
	FCS.DefineItem("p_eli3", {
		PrintName = "Cargo Pants (Gray)",
		Type = FCS_PANTS,
		BoneMods = ELIPANTS,
		Model = "models/fgut/pants_eli_10.mdl",
		Skin = 2,
	})
	FCS.DefineItem("p_eli4", {
		PrintName = "Cargo Pants (Blue)",
		Type = FCS_PANTS,
		BoneMods = ELIPANTS,
		Model = "models/fgut/pants_eli_10.mdl",
		Skin = 3,
	})

	FCS.DefineItem("p_blacksuit", {
		PrintName = "Suit Pants (Black)",
		Type = FCS_PANTS,
		Model = "models/fgut/hl2rp/blacksuit_legs_02.mdl",
	})

	FCS.DefineItem("p_admin", {
		PrintName = "Suit Pants (Brown)",
		Type = FCS_PANTS,
		Model = "models/fgut/hl2rp/admin_legs_01.mdl",
	})

	FCS.DefineItem("p_surplus", {
		PrintName = "Surplus Pants",
		Type = FCS_PANTS,
		Model = "models/fgut/hl2rp/surplus_pants_01.mdl",
	})

	-- FCS.DefineItem("p_hostage", {
	-- 	PrintName = "Worn Blue Jeans",
	-- 	Type = FCS_PANTS,
	-- 	Model = "models/fgut/pants_hostage_01.mdl",
	-- })


	local BEANIEFIX = {
		["female"] = {
			["ValveBiped.Bip01_Head1"] = {
				translate = v( -1.0, -1.0, 0 ),
				scale = v( 1, 0.9, 1 )
			},
		},
		["male_01"] = {
			["ValveBiped.Bip01_Head1"] = {
				translate = v( 0.3, -0.4, 0 ),
				scale = v( 1, 1.1, 1.1 )
			},
		},
		["male_03"] = {
			["ValveBiped.Bip01_Head1"] = {
				translate = v( 0.3, -0.5, 0 ),
				scale = v( 1, 1, 1 )
			},
		},
		["male_04"] = {
			["ValveBiped.Bip01_Head1"] = {
				translate = v( 0.6, -0.2, 0 ),
				scale = v( 1, 1, 1.1 )
			},
		},
	}
	FCS.DefineItem("p_beanie_black", {
		PrintName = "Beanie (Black)",
		Type = FCS_HAT,
		BoneMods = BEANIEFIX,
		Model = "models/fgut/hl2rp/beanie_black_01.mdl",
	})
	FCS.DefineItem("p_beanie_blue", {
		PrintName = "Beanie (Blue)",
		Type = FCS_HAT,
		BoneMods = BEANIEFIX,
		Model = "models/fgut/hl2rp/beanie_blue_01.mdl",
	})
	FCS.DefineItem("p_beanie_green", {
		PrintName = "Beanie (Green)",
		Type = FCS_HAT,
		BoneMods = BEANIEFIX,
		Model = "models/fgut/hl2rp/beanie_green_01.mdl",
	})
	FCS.DefineItem("p_beanie_gray", {
		PrintName = "Beanie (Gray)",
		Type = FCS_HAT,
		BoneMods = BEANIEFIX,
		Model = "models/fgut/hl2rp/beanie_grey_01.mdl",
	})
end

if CLIENT then
	local EYEIRIS = {
		"Engine/eye-iris-brown",
		"Engine/eye-iris-brown-dark",
		"Engine/eye-iris-black",
		"Engine/eye-iris-blue",
		"Engine/eye-iris-green",
		"Engine/eye-iris-green-light",
	}
	function PT:FCSEyeColor()
		return EYEIRIS[ math.Clamp( self:GetNW2Int( "FCS_EyeColor", 1 ), 1, #EYEIRIS ) ]
	end
	CreateClientConVar("fcs_eyecolor", 1, true, true)
	matproxy.Add({
		name = "FCS_EyeIrisTex",
		init = function( self, mat, values )
			--self.ResultTo = values.resultvar
		end,
		bind = function( self, mat, ent )
			if ent.FCSEyeColor then
				mat:SetTexture( "$Iris", ent:FCSEyeColor() )
			end
		end 
	})
	local TEMPGOAT = Vector()
	local function qv( i )
		return { i, i, i }
	end
	local dark_1 = { 0.45, 0.45, 0.4 }
	local dark_2 = { 0.5, 0.45, 0.40 }
	local dark_3 = { 0.42, 0.42, 0.38 }
	local dark_4 = { 0.35, 0.35, 0.35 }
	local light_1 = { 1.0, 0.9, 0.9 }
	local light_2 = qv( 0.8 )
	local light_3 = { 1.0, 0.95, 0.95 }
	local ebri_1 = { 1.5, 1.7, 1.8 }
	local ebri_2 = { 1.4, 1.4, 1.5 }
	local ebri_3 = { 1.4, 1.2, 1.5 }

	local f_w_1 = qv( 1.2 )
	local f_w_2 = { 1.3, 1.0, 1.0 }
	local f_w_3 = { 1.3, 1.4, 1.6 }
	local f_w_4 = { 1.6, 1.1, 1.1 }
	local f_w_5 = qv( 2 )
	
	local f_d_1 = { 0.5, 0.4, 0.4 }
	local f_d_2 = { 0.7, 0.65, 0.65 }
	local f_d_3 = { 0.6, 0.5, 0.5 }
	local f_d_4 = { 0.65, 0.55, 0.55 }
	local TONES = {
		["female_01"] = {
			[0] = f_w_1,
			[1] = f_w_1,
			[2] = f_w_3,
			[3] = f_w_4,
			[4] = f_w_2,
			[5] = f_w_1,
		},
		["female_02"] = {
			[1] = f_w_4,
			[2] = f_w_2,
		},
		["female_03"] = {
			[0] = f_d_2,
			[1] = f_d_2,
			[2] = f_d_1,
			[3] = f_d_3,
			[4] = f_d_4,
			[5] = f_d_3,
			[6] = f_d_2,
		},
		["female_04"] = {
			[1] = f_w_5,
			[2] = f_w_4,
		},
		["female_06"] = {
			[1] = f_d_2,
			[3] = f_w_4,
			[4] = f_w_2,
		},
		["female_07"] = {
			[0] = f_d_2,
			[1] = f_d_3,
			[2] = f_d_2,
			[3] = f_d_2,
		},
		["male_01"] = {
			[0] = dark_1,
			[1] = dark_2,
			[2] = dark_1,
			[3] = dark_1,
			[4] = dark_1,
			[5] = dark_1,
			[6] = dark_1,
			[7] = dark_1,
		},
		["male_02"] = {
			[2] = ebri_1,
			[3] = ebri_2,
		},
		["male_03"] = {
			[0] = dark_3,
			[1] = dark_3,
			[2] = dark_3,
			[3] = dark_2,
			[4] = dark_4,
			[5] = dark_3,
			[6] = dark_3,
			[7] = dark_3,
			[8] = dark_3,
		},
		["male_04"] = {
			[1] = ebri_1,
			[2] = ebri_2,
			[3] = ebri_2,
			[4] = ebri_2,
			[5] = ebri_2,
			[6] = ebri_2,
			[7] = { 0.8, 0.8, 0.75 },
		},
		["male_05"] = {
			[0] = light_1,
			[1] = light_1,
			[2] = light_3,
			[3] = light_3,
			[4] = light_2,
			[5] = light_3,
			[6] = light_3,
		},
		["male_06"] = {
			[2] = ebri_2,
		},
		["male_07"] = {
			[1] = { 0.75, 0.7, 0.7 },
			[3] = { 0.96, 1.1, 1.0 },
		},
		["male_08"] = {
			[0] = light_2,
			[1] = light_1,
			[2] = light_1,
			[3] = light_2,
			[4] = light_2,
			[5] = light_2,
			[6] = light_1,
			[7] = light_2,
			[8] = light_2,
		},
		["male_09"] = {
			[9] = { 1.4, 1.1, 1.0 },
		},
	}
	matproxy.Add({
		name = "FCS_SkinTone",
		init = function( self, mat, values )
			self.AreTheseHands = (values.arethesehands == 1)
		end,
		bind = function( self, mat, ent )
			TEMPGOAT[1] = 1
			TEMPGOAT[2] = 1
			TEMPGOAT[3] = 1
			local reader = ent
			if ent:IsValid() and self.AreTheseHands then
				reader = ent:GetOwner()
			end
			if ent:IsValid() and reader:IsValid() then
				local curmdl = reader:GetModel():sub( 13, 19 )
				local c_tone = TONES[curmdl]
				if !c_tone then
					curmdl = reader:GetModel():sub( 13, 21 )
					c_tone = TONES[curmdl]
				end
				if c_tone then
					local c_tone_skin = c_tone[reader:GetSkin()]
					if c_tone_skin then
						TEMPGOAT[1] = c_tone_skin[1]
						TEMPGOAT[2] = c_tone_skin[2]
						TEMPGOAT[3] = c_tone_skin[3]
					end
				end
			end
			-- Chell's hands are bit red-orangeish.
			if self.AreTheseHands then
				TEMPGOAT[1] = TEMPGOAT[1] * (082/80)
				TEMPGOAT[2] = TEMPGOAT[2] * (086/80)
				TEMPGOAT[3] = TEMPGOAT[3] * (100/80)
			end
			mat:SetVector( "$color2", TEMPGOAT )
		end 
	})

	hook.Add("PopulateToolMenu", "FCS_MenuOptions", function()
		spawnmenu.AddToolMenuOption("Options", "Fesiug's Character Solutions", "FCS_Clothing", "Clothing", "", "", function( panel )
			panel:AddControl("header", {
				description = "Change what your character looks like.",
			})
			local cbox = vgui.Create( "DComboBox", panel )
			cbox:Dock( TOP )
			cbox:DockMargin( 10, 10, 10, 0 )
			cbox:SetValue( "Eye Color" )
			cbox:SetSortItems( false )
			cbox:AddChoice( "Dark Brown",	1 )
			cbox:AddChoice( "Light Brown",	2 )
			cbox:AddChoice( "Black",		3 )
			cbox:AddChoice( "Blue",			4 )
			cbox:AddChoice( "Green",		5 )
			cbox:AddChoice( "Light Green",	6 )
			function cbox:OnSelect( index, value )
				RunConsoleCommand( "fcs_eyecolor", index )
			end
			for i, v in ipairs( FCS.TL ) do
				if v == FCS_SHIRT or v == FCS_PANTS then continue end
				panel:AddControl("button", { label = "Drop " .. FCS.TTS[v], command = "fcs_drop_" .. string.lower(FCS.TTS[v]) })
			end
		end)
	end)
end

function FCS.Random( typee )
	local selection = {}
	for i, v in pairs(FCS.Items) do
		if v.Type == typee then
			selection[#selection + 1] = i
		else
			continue
		end
	end
	return selection[math.random(1, #selection)]
end