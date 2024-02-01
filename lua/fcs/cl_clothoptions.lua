FCS.ClothOptionMenu = FCS.ClothOptionMenu or nil
FCS.ClothOptions = {}

function FCS.RemoveClothOptionMenu()
    if FCS.ClothOptionMenu then
        FCS.ClothOptionMenu:Remove()
        FCS.ClothOptionMenu = nil
    end
end

function FCS.CreateClothOptionMenu(ID)
    FCS.RemoveClothOptionMenu()

    local item = FCS.GetItem(ID)
    if not item or not item.Options then return end

    FCS.ClothOptionMenu = vgui.Create("DFrame")
    FCS.ClothOptionMenu:SetSize(300, 500)
    FCS.ClothOptionMenu:Center()
    FCS.ClothOptionMenu:MakePopup()
    FCS.ClothOptionMenu:SetTitle("Clothing Options")

    FCS.ClothOptions = {}

    if item.Options.Skins then
        local panel = vgui.Create("DPanel", FCS.ClothOptionMenu)
        panel:SetTall(48)
        panel:Dock(TOP)
        panel:DockMargin(0, 0, 0, 8)

        local text = vgui.Create("DLabel", panel)
        text:DockMargin(16, 16, 16, 16)
        text:Dock(LEFT)
        text:SetText("Skin Option")
        text:SetFont("DermaDefaultBold")
        text:SetTextColor(color_black)
        text:SizeToContents()

        local cbox = vgui.Create("DComboBox", panel)
        cbox:DockMargin(16, 12, 16, 12)
        cbox:SetSortItems(false)
        cbox:SetWide(160)
        cbox:Dock(RIGHT)
        function cbox:OnSelect(index, value, data)
            FCS.ClothOptions.Skin = data
        end
        for k, v in pairs(item.Options.Skins) do
            cbox:AddChoice(v, k, k == (item.Skin or 0))
        end
    end

    if item.Options.Bodygroups then
        local panel = vgui.Create("DPanel", FCS.ClothOptionMenu)
        panel:SetTall(48)
        panel:Dock(TOP)
        panel:DockMargin(0, 0, 0, 8)

        local text = vgui.Create("DLabel", panel)
        text:DockMargin(16, 16, 16, 16)
        text:Dock(LEFT)
        text:SetText("Variants")
        text:SetFont("DermaDefaultBold")
        text:SetTextColor(color_black)
        text:SizeToContents()

        local cbox = vgui.Create("DComboBox", panel)
        cbox:DockMargin(16, 12, 16, 12)
        cbox:SetWide(160)
        cbox:SetSortItems(false)
        cbox:Dock(RIGHT)
        function cbox:OnSelect(index, value, data)
            FCS.ClothOptions.Bodygroup = data
        end
        cbox:AddChoice("Default", 1, true)
    end

    if item.Options.Color then
        local panel = vgui.Create("DPanel", FCS.ClothOptionMenu)
        panel:SetTall(280)
        panel:Dock(TOP)
        panel:DockMargin(0, 0, 0, 8)

        local text = vgui.Create("DLabel", panel)
        text:DockMargin(16, 8, 16, 8)
        text:Dock(TOP)
        text:SetText("Custom Color")
        text:SetFont("DermaDefaultBold")
        text:SetTextColor(color_black)
        text:SizeToContents()

        local mixer = vgui.Create("DColorMixer", panel)
        mixer:Dock(FILL)
        mixer:DockMargin(4, 0, 4, 4)
        mixer:SetAlphaBar(false)
        function mixer:ValueChanged(col)
            FCS.ClothOptions.Color = col
        end
    end

    local apply = vgui.Create("DButton", FCS.ClothOptionMenu)
    apply:SetTall(48)
    apply:DockMargin(16, 16, 16, 8)
    apply:Dock(BOTTOM)
    apply:SetText("Apply Changes")
    apply:SetFont("DermaDefaultBold")
    function apply:DoClick()
        net.Start("FCS_Option")
            net.WriteString(ID)
            if item.Options.Skins then
                net.WriteUInt(FCS.ClothOptions.Skin or 0, 6)
            end
            if item.Options.Bodygroups then
                net.WriteUInt(FCS.ClothOptions.Bodygroup or 0, 6)
            end
            if item.Options.Color then
                net.WriteColor(FCS.ClothOptions.Color or color_white)
            end
        net.SendToServer()
        LocalPlayer():EmitSound("garrysmod/content_downloaded.wav", 0, 100, 0.75, CHAN_STATIC)
        FCS.ClothOptionMenu:Close()
    end
end

if false then
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

	render.PushRenderTarget(NewRT)
		render.OverrideDepthEnable( true, true )
		render.SetWriteDepthToDestAlpha( false )
		render.SuppressEngineLighting( true )

		for i, v in pairs( FCS.Items ) do
			local slots = FCS.SlotToList( v.Type )
			local POS, ANG, CL = POS_SHIRT, ANG_SHIRT, CL_SHIRT
			if v.Type == FCS_HAT then
				POS, ANG, CL = POS_HEAD, ANG_HEAD, CL_HEAD
				-- continue ----------------------------
			elseif v.Type == FCS_PANTS then
				POS, ANG, CL = POS_PANTS, ANG_PANTS, CL_PANTS
			else
				-- continue ----------------------------
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