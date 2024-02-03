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
	PrintName = "CWU (Orange)",
	Type = FCS_SHIRT,
	BoneMods = GENERICFIX,
	Model = "models/fgut/shirt_cmb01_02.mdl",
})

FCS.DefineItem("s_cmb2", {
	PrintName = "CWU (Yellow)",
	Type = FCS_SHIRT,
	BoneMods = GENERICFIX,
	Model = "models/fgut/shirt_cmb02_01.mdl",
})

FCS.DefineItem("s_cmb3", {
	PrintName = "CWU (Blue)",
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
	PrintName = "Buttoned Shirt (Tan)",
	Type = FCS_SHIRT,
	BoneMods = GENERICFIX,
	Model = "models/fgut/shirt_refugee01_01.mdl",
})

FCS.DefineItem("s_refugee2", {
	PrintName = "Buttoned Shirt (Olive)",
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

FCS.DefineItem("s_admin2", {
	PrintName = "Suit Top (Purple)",
	Type = FCS_SHIRT,
	BoneMods = GENERICFIX,
	Model = "models/fgut/hl2rp/admin_shirt_01.mdl",
	Skin = 1,
})

FCS.DefineItem("s_admin3", {
	PrintName = "Suit Top (Blue)",
	Type = FCS_SHIRT,
	BoneMods = GENERICFIX,
	Model = "models/fgut/hl2rp/admin_shirt_01.mdl",
	Skin = 2,
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

FCS.DefineItem("s_wintercoat1", {
	PrintName = "Winter Coat (Green)",
	Type = FCS_SHIRT,
	BoneMods = GENERICFIX,
	Model = "models/fgut/hl2rp/wintercoat_shirt_01.mdl",
})

FCS.DefineItem("s_wintercoat2", {
	PrintName = "Winter Coat (Brown)",
	Type = FCS_SHIRT,
	BoneMods = GENERICFIX,
	Model = "models/fgut/hl2rp/wintercoat_shirt2_01.mdl",
})

FCS.DefineItem("s_beta1", {
	PrintName = "Ragged Shirt (Pale)",
	Type = FCS_SHIRT,
	BoneMods = GENERICFIX,
	Model = "models/fgut/hl2rp/beta_shirt_01.mdl",
})

FCS.DefineItem("s_beta2", {
	PrintName = "Ragged Shirt (Green)",
	Type = FCS_SHIRT,
	BoneMods = GENERICFIX,
	Model = "models/fgut/hl2rp/beta_shirt2_01.mdl",
})

FCS.DefineItem("s_trenchcoat_brown", {
	PrintName = "Trenchcoat (Brown)",
	Type = FCS_SHIRT,
	BoneMods = GENERICFIX,
	Model = "models/fgut/hl2rp/trenchcoat_brown_01.mdl",
})

FCS.DefineItem("s_trenchcoat_black", {
	PrintName = "Trenchcoat (Black)",
	Type = FCS_SHIRT,
	BoneMods = GENERICFIX,
	Model = "models/fgut/hl2rp/trenchcoat_black_01.mdl",
})


-- Back
FCS.DefineItem("b_bag", {
	PrintName = "Bag",
	Type = FCS_BACK,
	Model = "models/fgut/hl2rp/bag_01.mdl",
})

FCS.DefineItem("b_satchel", {
	PrintName = "Satchel",
	Type = FCS_BACK,
	Model = "models/fgut/hl2rp/satchel_01.mdl",
})

-- Exo
FCS.DefineItem("e_elivest1", {
	PrintName = "Vest (Black)",
	Type = FCS_EXO,
	Model = "models/fgut/hl2rp/vest_01.mdl",
	Skin = 0,
})
FCS.DefineItem("e_elivest2", {
	PrintName = "Vest (Green)",
	Type = FCS_EXO,
	Model = "models/fgut/hl2rp/vest_01.mdl",
	Skin = 1,
})
FCS.DefineItem("e_elivest3", {
	PrintName = "Vest (Blue)",
	Type = FCS_EXO,
	Model = "models/fgut/hl2rp/vest_01.mdl",
	Skin = 2,
})
FCS.DefineItem("e_elivest4", {
	PrintName = "Vest (Red)",
	Type = FCS_EXO,
	Model = "models/fgut/hl2rp/vest_01.mdl",
	Skin = 3,
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

FCS.DefineItem("p_beta1", {
	PrintName = "Thick Jeans (Brown)",
	Type = FCS_PANTS,
	Model = "models/fgut/hl2rp/beta_legs_01.mdl",
})

FCS.DefineItem("p_beta2", {
	PrintName = "Thick Jeans (Gray)",
	Type = FCS_PANTS,
	Model = "models/fgut/hl2rp/beta_legs2_01.mdl",
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

FCS.DefineItem("p_admin2", {
	PrintName = "Suit Pants (Purple)",
	Type = FCS_PANTS,
	Model = "models/fgut/hl2rp/admin_legs_01.mdl",
	Skin = 1,
})

FCS.DefineItem("p_admin3", {
	PrintName = "Suit Pants (Blue)",
	Type = FCS_PANTS,
	Model = "models/fgut/hl2rp/admin_legs_01.mdl",
	Skin = 2,
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