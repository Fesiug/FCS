
local enabled = CreateConVar("fcscheer", 0, FCVAR_ARCHIVE+FCVAR_REPLICATED)
if CLIENT then
	CreateClientConVar("fcscheer_chat", 1, true, true, "Emotions in chat messages (like :D ) will activate a cheer expression.")
end

--[[
	eyes_updown
	eyes_rightleft
	right_lid_raiser
	left_lid_raiser
	right_lid_tightener
	left_lid_tightener
	right_lid_droop
	left_lid_droop
	right_lid_closer
	left_lid_closer
	half_closed
	blink
	right_inner_raiser
	left_inner_raiser
	right_outer_raiser
	left_outer_raiser
	right_lowerer
	left_lowerer
	right_cheek_raiser
	left_cheek_raiser
	wrinkler
	dilator
	right_upper_raiser
	left_upper_raiser
	right_corner_puller
	left_corner_puller
	right_corner_depressor
	left_corner_depressor
	chin_raiser
	right_part
	left_part
	right_puckerer
	left_puckerer
	right_funneler
	left_funneler
	right_stretcher
	left_stretcher
	bite
	presser
	tightener
	jaw_clencher
	jaw_drop
	right_mouth_drop
	left_mouth_drop
	smile
	lower_lip
	head_rightleft
	head_updown
	head_tilt
	eyes_updown
	eyes_rightleft
	body_rightleft
	chest_rightleft
	head_forwardback
	gesture_updown
	gesture_rightleft
]]

local facial = {
	[""] = true,
	["big_smile"] = {
		["smile"] = 1,
		["right_cheek_raiser"]		= 1,
		["left_cheek_raiser"]		= 1,
		["right_inner_raiser"]		= 0.8,
		["left_inner_raiser"]		= 0.8,
	},
	["smile"] = {
		["left_stretcher"] = 0,
		["right_stretcher"] = 0,
		["left_corner_puller"] = 0.3,
		["right_corner_puller"] = 0.3,
		["right_cheek_raiser"]		= 1,
		["left_cheek_raiser"]		= 1,
	},
	["wary"] = {
		["right_lid_raiser"]		= 1,
		["left_lid_raiser"]			= 1,

		["right_inner_raiser"]		= 1,
		["left_inner_raiser"]		= 1,
		["right_outer_raiser"]		= 0,
		["left_outer_raiser"]		= 0,

		["right_corner_depressor"]	= 0,
		["left_corner_depressor"]	= 0,
		["jaw_clencher"]			= 0.5,
		["chin_raiser"]				= 0.5,
		["presser"]					= 1,
		
		["left_stretcher"] = 1,
		["right_stretcher"] = 1,
	},
	["annoyed"] = {
		["right_corner_depressor"]	= 0.6,
		["left_corner_depressor"]	= 0.6,
		["presser"]					= 1,
		["right_lowerer"]		= 1,
		["left_lowerer"]		= 1,
		["right_lid_tightener"]		= 0.6,
		["left_lid_tightener"]		= 0.6,
		["right_lid_closer"]		= 0.0,
		["left_lid_closer"]		= 0.0,
		["right_outer_raiser"]		= 0.5,
		["left_outer_raiser"]		= 0.5,
		["right_inner_raiser"]		= -0.5,
		["left_inner_raiser"]		= -0.5,
	},
	["wink"] = {
		["left_stretcher"] = 0,
		["right_stretcher"] = 0,
		["left_corner_puller"] = 0.3,
		["right_corner_puller"] = 0.3,
		["right_cheek_raiser"]		= 1,
		["left_cheek_raiser"]		= 1,
		["right_lid_closer"]		= 0.9,
	},
	["evil_smile"] = {
		["right_corner_depressor"]	= 0.6,
		["left_corner_depressor"]	= 0.6,
		["presser"]					= 0,
		["right_lowerer"]		= 1,
		["left_lowerer"]		= 1,
		["right_lid_tightener"]		= 0.6,
		["left_lid_tightener"]		= 0.6,
		["right_lid_closer"]		= 0.0,
		["left_lid_closer"]		= 0.0,
		["right_outer_raiser"]		= 0.5,
		["left_outer_raiser"]		= 0.5,
		["right_inner_raiser"]		= 0,
		["left_inner_raiser"]		= 0,

		["left_stretcher"] = 0,
		["right_stretcher"] = 0,
		["left_corner_puller"] = 0.3,
		["right_corner_puller"] = 0.3,
		["right_cheek_raiser"]		= 1,
		["left_cheek_raiser"]		= 1,
		["smile"] = 1,
	},
	["surprised"] = {
		["right_lid_raiser"]		= 1,
		["left_lid_raiser"]			= 1,
		["right_inner_raiser"]		= 1,
		["left_inner_raiser"]		= 1,
		["right_outer_raiser"]		= 0.58,
		["left_outer_raiser"]		= 0.56,
		["left_corner_puller"]		= 1,
		["right_corner_puller"]		= 1,
		["right_corner_depressor"]	= 1,
		["left_corner_depressor"]	= 1,
		["right_part"]				= 1,
		["left_part"]				= 1,
		["right_stretcher"]			= 1,
		["left_stretcher"]			= 1,
		["jaw_clencher"]			= 1,
		["jaw_drop"]				= 1,
		["right_mouth_drop"]		= 1,
		["left_mouth_drop"]			= -1,
	},
	["sad"] = {
		["right_corner_depressor"]	= 1,
		["left_corner_depressor"]	= 1,
		["chin_raiser"]				= 1,
		["right_lid_droop"]			= 1,
		["left_lid_droop"]			= 1,
		["right_inner_raiser"]		= 1,
		["left_inner_raiser"]		= 1,
	},
}

local chat_to_facial = {
	[":("] = "sad",
	[":["] = "sad",
	["=("] = "sad",
	[":)"] = "smile",
	[":]"] = "smile",
	["=)"] = "smile",
	[":D"] = "big_smile",
	[">:)"] = "evil_smile",
	[">:]"] = "evil_smile",
	[">:D"] = "evil_smile",
	[">=)"] = "evil_smile",
	[">=]"] = "evil_smile",
	[">=D"] = "evil_smile",
	[">:("] = "annoyed",
	[">:["] = "annoyed",
	["D:<"] = "annoyed",
	[":O"] = "surprised",
	[":0"] = "surprised",
	[":o"] = "surprised",
	[":c"] = "wary",
	[":I"] = "wary",
	[":L"] = "wary",
	[":|"] = "wary",
	[":l"] = "wary",
	[";)"] = "wink",
}

hook.Add("UpdateAnimation", "Cheer_UpdateAnimation", function(ply, vel)
	if enabled:GetBool() then

	if (ply.lastgen or 0) < CurTime() then
		local tweak = 1/1
		local ttime = math.Rand( 0.0, 2 )
		ply.lastgen = CurTime() + ttime * tweak
		if ttime <= 0.2 then
			ply.eye_rand_p = (ply.eye_rand_p or 0) + math.Rand( -5, 5 )
			ply.eye_rand_y = (ply.eye_rand_y or 0) + math.Rand( -5, 5 )
		else
			ply.eye_rand_p = math.Rand( -5, 5 ) / tweak
			ply.eye_rand_y = math.Rand( -10, 10 ) / tweak
		end
	end

	ply.eye_rand_p_lerp = math.Approach( (ply.eye_rand_p_lerp or 0), (ply.eye_rand_p or 0), FrameTime()*400 )
	ply.eye_rand_y_lerp = math.Approach( (ply.eye_rand_y_lerp or 0), (ply.eye_rand_y or 0), FrameTime()*400 )

	local a = ply:EyeAngles()
	a.p = a.p + ply.eye_rand_p_lerp
	a.y = a.y + ply.eye_rand_y_lerp
	local funnytrace = {
		start = ply:EyePos(),
		endpos = ply:EyePos() + ply:EyeAngles():Forward()*1024,
		filter = ply,
	}

	funnytrace = util.TraceLine( funnytrace )
	local fe = funnytrace.Entity
	local heh
	if fe:IsValid() and (fe:IsPlayer() or fe:IsNPC() or fe:IsNextBot()) and fe.EyePos then
		ply:SetEyeTarget( fe:EyePos() )
		heh = fe:EyePos()
	else
		local funnytrace = {
			start = ply:EyePos(),
			endpos = ply:EyePos() + a:Forward()*1024,
			filter = ply,
		}
		funnytrace = util.TraceLine( funnytrace )
		ply:SetEyeTarget( funnytrace.HitPos )
		heh = funnytrace.HitPos
	end

	--if CLIENT then
	--	debugoverlay.Cross( heh, 4, 0.1, color_white, true )
	--	local v1 = (Player(4):EyePos() - ply:GetAttachment( ply:LookupAttachment("eyes") ).Pos):GetNormalized()
	--	v1.z = 0
	--	local v2 = ply:GetForward()
	--	v2.z = 0
	--	--debugoverlay.Line( ply:GetAttachment( ply:LookupAttachment("eyes") ).Pos, heh, 4, 0.1, color_white, true )
	--	
	--	local dot = v1:Dot(v2)
--
	--	--print(ply)
	--	if ply != LocalPlayer() then
	--		ply:SetPoseParameter( "head_yaw", dot*-75)
	--	end
	--end
	
	local cheer_active = ply:GetNW2String( "Cheer_Active" )
	local cheer_prev = ply:GetNW2String( "Cheer_Last" )
	local cheer_ctime = ply:GetNW2Float( "Cheer_ChangeTime", 0 )
	local ctime = math.ease.OutExpo( math.min( CurTime() - cheer_ctime, 1)/1 )

	for i=0, ply:GetFlexNum()-1 do
		local fname = ply:GetFlexName( i )

		local to = 0

		--if facial[cheer_active] then
		--	if facial[cheer_active] == true then
		--	else
		--		to = Lerp( ctime, 0, facial[cheer_active][fname] )
		--	end
		--end
		local WEIGHT_FROM = 0
		local WEIGHT_TO = 0

		if cheer_prev != "" and facial[cheer_prev] then
			WEIGHT_FROM = facial[cheer_prev][fname] or 0
		else
			WEIGHT_FROM = 0
		end

		if cheer_active != "" and facial[cheer_active] then
			WEIGHT_TO = facial[cheer_active][fname] or 0
		else
			WEIGHT_TO = 0
		end

		to = Lerp( ctime, WEIGHT_FROM, WEIGHT_TO )
		ply:SetFlexWeight( i, to )
	end

	--if cheer_active != "" and facial[cheer_active] then
	--	for FlexName, FlexWeight in pairs( facial[cheer_active] ) do
	--		ply:SetFlexWeight( ply:GetFlexIDByName(FlexName), FlexWeight*ctime )
	--	end
	--end
	end

	if CLIENT and (ply:IsSpeaking() or ply:VoiceVolume() == 0) then
		GAMEMODE:GrabEarAnimation( ply )
		return true -- Block default mouth flapping so our flexes take effect
	end
end)

if SERVER then
	util.AddNetworkString("Cheer_RequestFace")
	net.Receive("Cheer_RequestFace", function( len, ply )
		if enabled:GetBool() then
			local face = net.ReadString()
			if face == "" or facial[face] then
				ply:SetNW2String( "Cheer_Last", ply:GetNW2String("Cheer_Active", "") )
				ply:SetNW2String( "Cheer_Active", face )
				ply:SetNW2Float( "Cheer_ChangeTime", CurTime() )
			end
		end
	end)

	hook.Add("PlayerSay", "Cheer_ChatToCheer", function(ply, text, isTeam)
		if not enabled:GetBool() or isTeam or not ply:Alive() or ply:GetInfoNum("fcscheer_chat", 1) == 0 then return end
		local cheer = nil
		for k, v in pairs(chat_to_facial) do
			if string.find(text, k, nil, true) then
				cheer = v
				break
			end
		end
		if cheer then
			ply:SetNW2String( "Cheer_Last", ply:GetNW2String("Cheer_Active", "") )
			ply:SetNW2String( "Cheer_Active", cheer )
			ply:SetNW2Float( "Cheer_ChangeTime", CurTime() )
		end
	end)
end

local lastalt = 0
local function CheerUI()
	if CUI and CUI:IsValid() then CUI:Remove() CUI = nil end
	if !enabled:GetBool() then return end

	local s = ScreenScaleH

	CUI = vgui.Create("DFrame")
	CUI:SetSize( s( 200 ), s( 150 ) )
	CUI:Center()
	CUI:SetY( ScrH()/2 + s( 50 ) )
	CUI:MakePopup()
	CUI:SetKeyboardInputEnabled( false )

	local Scroller = CUI:Add("DScrollPanel")
	Scroller:Dock( FILL )
	Scroller.VBar:SetWidth( s(4) )

	for facename, v in SortedPairs( facial ) do
		local button = Scroller:Add("DButton")
		button:Dock(TOP)
		button:SetText( facename == "" and "* none *" or facename )
		button:SetTall( s( 16 ) )
		button:DockMargin( 0, 0, 0, s(2) )
		
		function button:DoClick()
			net.Start("Cheer_RequestFace")
				net.WriteString(facename)
			net.SendToServer()
			CUI:Remove()
		end
	end
end

hook.Add("PlayerButtonDown", "Cheer_PlayerButtonDown", function( ply, key )
	if CLIENT and enabled:GetBool() then
		if key == KEY_LALT and IsFirstTimePredicted() then
			--print("Hey", lastalt, CurTime()-lastalt)
			if (CurTime() - lastalt) < 0.25 then
				--print("Right!")
				CheerUI()
				lastalt = -math.huge
			else
				if CUI and CUI:IsValid() then CUI:Remove()
				else
					lastalt = CurTime()
				end
			end
		end
	end
end)
-- hook.Add("Think", "Cheer_Think", function()
-- end)

if CLIENT then
	hook.Add("PopulateToolMenu", "FCS_Cheer_MenuOptions", function()
		spawnmenu.AddToolMenuOption("Options", "Fesiug's Clothing Solutions", "FCS_Cheer", "Cheer", "", "", function( panel )
			panel:AddControl("header", {
				description = "Change your characters emotion.",
			})
			panel:AddControl("checkbox", {
				label = "Enable Cheer",
				command = "fcscheer",
			})
			panel:ControlHelp("You should change level after changing this.\n")
			panel:ControlHelp("Double-tap ALT to open the panel, or find it in the Context Menu.")
			panel:Help("There is a bug where the eyes may flicker.\nGive it a minute and should resolve itself, or try tabbing out for a second.\nThe cause is unknown.")

			panel:AddControl("checkbox", {
				label = "Chat Emoticons Trigger Cheer",
				command = "fcscheer_chat",
			})
			panel:Help("Client option to make certain emoticons like :D or :( trigger emotion on your character.")
		end)
	end)
	if enabled:GetBool() then
		list.Set( "DesktopWindows", "FCS_Cheer_Icon", {
			title = "FCS Cheer",
			icon = "icon16/emoticon_happy.png",
			init = function( icon, window )
				CheerUI()
			end
		} )
	end
end