local troll = false
hook.Add("ShouldDrawLocalPlayer", "TEST_ShouldDrawLocalPlayer", function()
	return troll
end)

local scaleme = 0

local enable = CreateClientConVar("fcspaperdoll", 0, true, false)
local clight = CreateClientConVar("fcspaperdoll_clight", 1, true, false)
local zout = CreateClientConVar("fcspaperdoll_bind_zoomout", KEY_MINUS, true, false)
local zin = CreateClientConVar("fcspaperdoll_bind_zoomin", KEY_EQUAL, true, false)

local accel = 0

hook.Add("Think", "TEST_Think", function()
	local p = LocalPlayer()

	local isit = input.IsKeyDown( zout:GetInt() ) or input.IsKeyDown( zin:GetInt() )
	if isit then
		accel = math.Approach( accel, 1, FrameTime() )
	else
		accel = 0
	end
	scaleme = math.Approach( scaleme, input.IsKeyDown( zout:GetInt() ) and 0 or input.IsKeyDown( zin:GetInt() ) and 1 or scaleme, FrameTime()/0.2*accel )
end)

local CustomLights = {
	{
		def_f = -32,
		def_r = -64,
		def_u = -64,
		type = MATERIAL_LIGHT_POINT,
		color = Vector(1, 1, 1)*-1.4,
	},
	{
		def_f = 256,
		def_r = 32,
		def_u = 128,
		type = MATERIAL_LIGHT_POINT,
		color = Vector(1, 1, 1)*1.4,
	},
}


hook.Add("HUDPaint", "TEST_HUDPaint", function()
	if !enable:GetBool() then return end
	local super = Lerp( scaleme, 1, 2 )

	local p = LocalPlayer()
	local e, a = p:EyePos(), p:EyeAngles()
	local lap = p:GetAttachment(p:LookupAttachment("eyes"))
	e = Vector( Lerp( scaleme, e.x, lap.Pos.x), Lerp( scaleme, e.y, lap.Pos.y), lap.Pos.z )
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
		local cligh = clight:GetBool()
			if cligh then
				render.SuppressEngineLighting( true )
				for i, v in ipairs( CustomLights ) do
					v.pos = p:GetPos()

					local nf = p:GetForward()
					local nr = p:GetRight()
					local nu = p:GetUp()
					nf:Mul(v.def_f)
					nr:Mul(v.def_r)
					nu:Mul(v.def_u)
					v.pos:Add( nf )
					v.pos:Add( nr )
					v.pos:Add( nu )
					v.dir = -p:GetForward()
				end
			end
			render.SetLocalModelLights(CustomLights)
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

			if cligh then render.SuppressEngineLighting( false ) end
		troll = false
		-- Flush ShouldDrawLocalPlayer cache, otherwise reload sounds and other stuff goes funny
		cam.Start({})
		cam.End()
	cam.End3D()
end)

hook.Add("PopulateToolMenu", "FCS_PaperDoll_MenuOptions", function()
	spawnmenu.AddToolMenuOption("Options", "Fesiug's Clothing Solutions", "FCS_PaperDoll", "Paper Doll", "", "", function( panel )
		panel:AddControl("header", {
			description = "Show a miniature portrait of your character.",
		})
		panel:AddControl("checkbox", {
			label = "Enable Paper Doll",
			command = "fcspaperdoll",
		})
		panel:AddControl("checkbox", {
			label = "Custom Lights",
			command = "fcspaperdoll_clight",
		})

		panel:KeyBinder("Zoom Out", "fcspaperdoll_bind_zoomout")
		panel:KeyBinder("Zoom In", "fcspaperdoll_bind_zoomin")

		--panel:ControlHelp("Several bugs from drawing the player right now, including:\n- Weird particle positions\n- Not hearing reload sounds\n- Odd first-person animations")
	end)
end)
local firsttime = true
list.Set( "DesktopWindows", "FCS_PaperDoll_Icon", {
	title = "FCS Paper Doll",
	icon = "icon16/zoom.png",
	init = function( icon, window )
		GetConVar("fcspaperdoll"):SetBool( !GetConVar("fcspaperdoll"):GetBool() )
		if firsttime and GetConVar("fcspaperdoll"):GetBool() then
			chat.AddText( color_white, "Press " .. input.GetKeyName( GetConVar("fcspaperdoll_bind_zoomout"):GetInt() ) .. " and " .. input.GetKeyName( GetConVar("fcspaperdoll_bind_zoomin"):GetInt() ) .. " to zoom out and in." )
			firsttime = false
		end
	end
} )