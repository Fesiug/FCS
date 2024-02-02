
-- TODO: Significantly better UI to pose and save icons.

if false and CLIENT then
	local function ICO_Initialize()
		if IsValid( mdl ) then mdl:Remove() end
		if IsValid( mdl2 ) then mdl2:Remove() end
		mdl = ClientsideModel( "models/fgut/male_07_01.mdl", RENDERGROUP_OTHER )
		mdl2 = ClientsideModel( "models/fgut/shirt_03_01.mdl", RENDERGROUP_OTHER )
	
		mdl:SetNoDraw( true )
		mdl2:SetNoDraw( true )
	
		-- Setup the player pose
		mdl:SetBodygroup( 0, 0 )
		mdl:SetBodygroup( 1, 1 )
		mdl:SetBodygroup( 2, 1 )
	
		mdl:ResetSequence( mdl:LookupSequence("pose_standing_02") )
		mdl:SetCycle( 0 )
		mdl:SetPlaybackRate( 0 )
	
		-- Setup the clothes to display
		mdl2:SetParent( mdl )
		mdl2:AddEffects( EF_BONEMERGE )
		mdl2:AddEffects( EF_BONEMERGE_FASTCULL )
	
		mdl:ManipulateBoneAngles( mdl:LookupBone("ValveBiped.Bip01_L_Clavicle"), Angle( -20, 0, -30 ), false )
		mdl:ManipulateBoneAngles( mdl:LookupBone("ValveBiped.Bip01_L_Forearm"), Angle( 0, -40, 0 ), false )
		mdl:ManipulateBoneAngles( mdl:LookupBone("ValveBiped.Bip01_L_Hand"), Angle( 0, -90, 0 ), false )

		return mdl, mdl2
	end

	local mdl, mdl2 = ICO_Initialize()

	local NewRT = GetRenderTarget("SaveAs", 512, 512)

	if !file.Exists("fcs_devgen", "DATA") then
		file.CreateDir("fcs_devgen")
	end

	local POS_SHIRT		= Vector( 120, 0, 49 )
	local ANG_SHIRT		= Angle( 0, 180, 0 )
	local CL_SHIRT		= {
		{
			type = MATERIAL_LIGHT_SPOT,
			color = Vector( 1, 1, 1 )*2,
			pos = Vector( 64, -48, 94 ),
			dir = Angle( 40, 180-40, 0 ):Forward(),
		},
		{
			type = MATERIAL_LIGHT_SPOT,
			color = Vector( -1, -1, -1 )*2,
			pos = Vector( -32, 48, -16 ),
			dir = Angle( -140, 180+40, 0 ):Forward(),
		},
	}

	local POS_PANTS		= Vector( 180, 0, 20 )
	local ANG_PANTS		= Angle( 0, 180, 0 )
	local CL_PANTS		= {
		{
			type = MATERIAL_LIGHT_SPOT,
			color = Vector( 1, 1, 1 )*2,
			pos = Vector( 64, 0, 64 ),
			dir = Angle( 40, 180, 0 ):Forward(),
		},
		{
			type = MATERIAL_LIGHT_SPOT,
			color = Vector( -1, -1, -1 )*2,
			pos = Vector( 16, 0, -64 ),
			dir = Angle( -80, 180, 0 ):Forward(),
		},
	}

	local POS_HEAD		= Vector( 50, -1, 85 )
	local ANG_HEAD		= Angle( 20, 180, 0 )
	local CL_HEAD		= {
		{
			type = MATERIAL_LIGHT_SPOT,
			color = Vector( 1, 1, 1 )*2,
			pos = Vector( 40, -40, 128 ),
			dir = Angle( 40, 180-40, 0 ):Forward(),
		},
		{
			type = MATERIAL_LIGHT_SPOT,
			color = Vector( -1, -1, -1 )*2,
			pos = Vector( -16, 48, 16 ),
			dir = Angle( -140, 180+40, 0 ):Forward(),
		},
	}

	local POS_EYES		= Vector( 50, -0.5, 77 )
	local ANG_EYES		= Angle( 15, 180, 0 )
	local CL_EYES		= CL_HEAD

	local POS_BACK		= Vector( -120, 53, 83 )
	local ANG_BACK		= Angle( 15, -25, 0 )
	local CL_BACK		= {
		{
			type = MATERIAL_LIGHT_SPOT,
			color = Vector( 1, 1, 1 )*2,
			pos = Vector( 64, -48, 94 ),
			dir = Angle( 40, 180-40, 0 ):Forward(),
		},
		{
			type = MATERIAL_LIGHT_SPOT,
			color = Vector( -1, -1, -1 )*2,
			pos = Vector( -32, 48, -16 ),
			dir = Angle( -140, 180+40, 0 ):Forward(),
		},
	}

	render.PushRenderTarget(NewRT)
		render.OverrideDepthEnable( true, true )
		render.SetWriteDepthToDestAlpha( false )
		render.SuppressEngineLighting( true )
		
		local function HasT( typ, types )
			return bit.band( typ, types ) == typ
		end

		for i, v in pairs( FCS.Items ) do
			local slots = FCS.SlotToList( v.Type )
			local POS, ANG, CL = POS_SHIRT, ANG_SHIRT, CL_SHIRT
			
			if HasT(FCS_EYES, v.Type) or HasT(FCS_MOUTH, v.Type) then
				do continue end
				POS, ANG, CL = POS_EYES, ANG_EYES, CL_EYES
			elseif HasT(FCS_HAT, v.Type) then
				do continue end
				POS, ANG, CL = POS_HEAD, ANG_HEAD, CL_HEAD
			elseif HasT(FCS_BACK, v.Type) then
				--do continue end
				POS, ANG, CL = POS_BACK, ANG_BACK, CL_BACK
			elseif HasT(FCS_PANTS, v.Type) then
				do continue end
				POS, ANG, CL = POS_PANTS, ANG_PANTS, CL_PANTS
			else
				do continue end
			end

			render.SetLocalModelLights(CL)
			
			for i, v in ipairs( CL ) do
				debugoverlay.Axis( v.pos, v.dir:Angle(), 16, 4, true )
			end

			mdl2:SetModel( v.Model )
			mdl2:SetSkin( v.Skin or 0 )
			render.Clear( 0, 127, 127, 0 )
			render.ClearDepth( true )
			
			cam.Start3D( POS, ANG, 14, 0, 0, 512, 512, 1, 1000 )
				mdl:SetupBones()
				mdl2:SetupBones()
				--mdl:DrawModel()
				mdl2:DrawModel()
			cam.End3D()
		
			if true then
				local data = render.Capture( {
					format = "png",
					x = 0,
					y = 0,
					w = 512,
					h = 512
				} )
				file.Write( "fcs_devgen/" .. i .. ".png", data )
			end
		end
		render.SuppressEngineLighting( false )
		render.OverrideDepthEnable( false )
	render.PopRenderTarget()
	mdl:Remove()
	mdl2:Remove()

	local myMat2 = CreateMaterial( "ExampleRTMat2", "UnlitGeneric", {
		["$basetexture"] = NewRT:GetName(), -- Make the material use our render target texture
		["$translucent"] = 1,
		["$vertexcolor"] = 1,
		["$vertexalpha"] = 1,
	} )

	hook.Add("HUDPaint", "Wawa", function()
		local w, h = 512, 512
		local x, y = ScrW()*(3/4) - (512/2), ScrH()/2 - (512/2)
		
		surface.SetDrawColor( 127, 127, 127 )
		surface.DrawRect( x, y, w, h )
		
		surface.SetDrawColor( 255, 255, 255 )
		surface.SetMaterial( myMat2 )
		surface.DrawTexturedRect( x, y, 512, 512 )

		surface.SetDrawColor( 255, 255, 255, 31 )
		for i=1, 4 do
			surface.DrawRect( x+(i/5)*512, y, 1, 512 )
		end
		for i=1, 4 do
			surface.DrawRect( x, y+(i/5)*512, 512, 1 )
		end
	end)
else
	if IsValid( mdl ) then mdl:Remove() end
	if IsValid( mdl2 ) then mdl2:Remove() end
	hook.Remove("HUDPaint", "Wawa")
end