
FCS = {}

--local files, dirs = file.Find("fcs/*.lua", "LUA")
--for i, filename in ipairs(files) do
--	if filename:Left(3) == "cl_" then
--		AddCSLuaFile("fcs/" .. filename)
--		if CLIENT then
--			include	("fcs/" .. filename)
--		end
--	elseif filename:Left(3) == "sv_" then
--		if SERVER then
--			include	("fcs/" .. filename)
--		end
--	else
--		AddCSLuaFile("fcs/" .. filename)
--		include		("fcs/" .. filename)
--	end
--end


local A_CL, INCL = AddCSLuaFile, include

A_CL	("fcs/clothes.lua")
INCL	("fcs/clothes.lua")

A_CL	("fcs/clothes_damage.lua")
INCL	("fcs/clothes_damage.lua")

A_CL	("fcs/cl_clothoptions.lua")
A_CL	("fcs/cl_paperdoll.lua")
if CLIENT then
	INCL("fcs/cl_clothoptions.lua")
	INCL("fcs/cl_paperdoll.lua")
end

-- It's big and it's ugly!
--A_CL	("fcs/cl_iconmaker.lua")
--if CLIENT then
--	INCL	("fcs/cl_iconmaker.lua")
--end

A_CL	("fcs/cheer.lua")
INCL	("fcs/cheer.lua")

local files, dirs = file.Find("fcs/items/*.lua", "LUA")
for i, filename in ipairs(files) do
	AddCSLuaFile("fcs/items/" .. filename)
	include		("fcs/items/" .. filename)
end
