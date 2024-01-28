local troll = false
hook.Add("ShouldDrawLocalPlayer", "TEST_ShouldDrawLocalPlayer", function()
	return troll
end)

local scaleme = 0.5
hook.Add("Think", "TEST_Think", function()
	local p = LocalPlayer()
	scaleme = math.Approach( scaleme, input.IsKeyDown( KEY_MINUS ) and 0 or input.IsKeyDown( KEY_EQUAL ) and 1 or scaleme, FrameTime()/0.2 )
end)

local enable = CreateClientConVar("fcspaperdoll", 0, true, false)

hook.Add("HUDPaint", "TEST_HUDPaint", function()
	if !enable:GetBool() then return end
	local super = Lerp( scaleme, 1, 2 )

	local p = LocalPlayer()
	local e, a = p:EyePos(), p:EyeAngles()
	local lap = p:GetAttachment(p:LookupAttachment("eyes"))
	e = Vector( e.x, e.y, lap.Pos.z )
	e.z = e.z - Lerp( math.ease.OutQuint( scaleme ), 30, 1 )
	a.p = 0
	a.r = 0
	a.y = p:GetRenderAngles().y - 180 - Lerp( scaleme, 20, 0 )
	local f, r, u = a:Forward(), a:Right(), a:Up()
	e = e - f*Lerp( scaleme, 440, 160 ) - r*0

	local s = ScreenScaleH
	local x, y, w, h = s( Lerp( scaleme, 0, 32 )), s(24), s( Lerp( scaleme, 130, 260 ) ), s( Lerp( scaleme, 130, 260 ) )
	
	--surface.SetDrawColor( 255, 255, 255, 2^4 )
	--surface.DrawRect( x,y,w,h )
	cam.Start3D( e, a, Lerp( scaleme, 10, 4 ), x,y,w,h )
		local wasiton = false
		troll = true
			--render.SuppressEngineLighting( true )
			p:DrawModel()

			for i, v in ipairs( FCS.TL ) do
				local nw2 = p:GetNW2Entity( "FCS_" .. FCS.TTS[ v ], NULL )
				if nw2:IsValid() then
					nw2:DrawModel()
				end
			end

			if IsValid(p:GetActiveWeapon()) then
				p:GetActiveWeapon():DrawModel()
			end

			--render.SuppressEngineLighting( false )
		troll = false
		-- Flush ShouldDrawLocalPlayer cache, otherwise reload sounds and other stuff goes funny
		cam.Start({})
		cam.End()
	cam.End3D()
end)

if CLIENT then
	hook.Add("PopulateToolMenu", "FCS_PaperDoll_MenuOptions", function()
		spawnmenu.AddToolMenuOption("Options", "Fesiug's Clothing Solutions", "FCS_PaperDoll", "Paper Doll", "", "", function( panel )
			panel:AddControl("header", {
				description = "Show a miniature portrait of your character.",
			})
			panel:AddControl("checkbox", {
				label = "Enable Paper Doll",
				command = "fcspaperdoll",
			})
			panel:ControlHelp("Several bugs from drawing the player right now, including:\n- Weird particle positions\n- Not hearing reload sounds\n- Odd first-person animations")
			panel:ControlHelp("Press - and + to zoom in and out.")
		end)
	end)
	local firsttime = true
	list.Set( "DesktopWindows", "FCS_PaperDoll_Icon", {
		title = "FCS Paper Doll",
		icon = "icon16/zoom.png",
		init = function( icon, window )
			GetConVar("fcspaperdoll"):SetBool( !GetConVar("fcspaperdoll"):GetBool() )
			if firsttime and GetConVar("fcspaperdoll"):GetBool() then
				chat.AddText( color_white, "Press - and + to zoom out and in." )
				firsttime = false
			end
		end
	} )
end