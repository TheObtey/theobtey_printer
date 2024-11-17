-- Loader file for 'theobtey_printer'
-- Automatically created by gcreator (github.com/wasied)
OBTPRINT = OBTPRINT or {}

-- Make loading functions
local function Inclu(f) return include("theobtey_printer/"..f) end
local function AddCS(f) return AddCSLuaFile("theobtey_printer/"..f) end
local function IncAdd(f) return Inclu(f), AddCS(f) end

-- Load addon files
IncAdd("config.lua")

if SERVER then
	
	resource.AddSingleFile("resource/fonts/K2D-Bold.ttf")
	resource.AddSingleFile("resource/fonts/K2D-ExtraBold.ttf")
	resource.AddSingleFile("resource/fonts/K2D-Light.ttf")
	resource.AddSingleFile("resource/fonts/K2D-Medium.ttf")
	resource.AddSingleFile("resource/fonts/K2D-SemiBold.ttf")
	resource.AddSingleFile("resource/fonts/K2D-Thin.ttf")
	resource.AddSingleFile("resource/fonts/K2D-Italic.ttf")

	AddCS("resources.lua")
	AddCS("client/imgui.lua")

else

	OBTPRINT.imgui = Inclu("client/imgui.lua")

	Inclu("resources.lua")

end