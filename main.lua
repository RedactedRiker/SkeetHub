local UILib = (loadstring(game:HttpGet("https://raw.githubusercontent.com/RedactedRiker/SkeetHub/main/Dependencies/library.lua")))();
local Window = UILib.new("Operation: Siege", game.Players.LocalPlayer.UserId, "Buyer");

--[[
	CC = Combat Catagory
	SC = Settings Catagory
]]--

local isInjected -- REMOVE THIS

local CombatCategory = Window:Category("Combat", "http://www.roblox.com/asset/?id=18438759105");
local VisualsCategory = Window:Category("Visuals", "http://www.roblox.com/asset/?id=18438764404");
local MiscCategory = Window:Category("Misc", "http://www.roblox.com/asset/?id=18438761439");
local SettingsCategory = Window:Category("Settings", "http://www.roblox.com/asset/?id=18438766957");

local CCButton1 = CombatCategory:Button("Rage", "http://www.roblox.com/asset/?id=8395747586");
local CCButton2 = CombatCategory:Button("Legit", "http://www.roblox.com/asset/?id=8395747586");

local SCButton1 = SettingsCategory:Button("Main", "http://www.roblox.com/asset/?id=8395747586");

local CCSection1 = CCButton1:Section("Rage Features", "Left");
local CCSection2 = CCButton2:Section("Legit Features", "Left")

local SCSection1 = SCButton1:Section("Unload", "Left");

-- Theoretically i think opSiege lib loading works?
-- TESTING it now

-- Combat Category
CCSection1:Button({
	Title = "Kill All",
	ButtonName = "KILL!!",
	Description = "kills everyone"
}, function(value)
	print(value);
end);

CCSection1:Toggle({
	Title = "Auto Farm Coins",
	Description = "Optional Description here",
	Default = false
}, function(value)
	print(value);
end);

CCSection1:Slider({
	Title = "Walkspeed",
	Description = "",
	Default = 16,
	Min = 0,
	Max = 120
}, function(value)
	print(value);
end);

CCSection1:ColorPicker({
	Title = "Colorpicker",
	Description = "",
	Default = Color3.new(255, 0, 0)
}, function(value)
	print(value);
end);

CCSection1:Textbox({
	Title = "Damage Multiplier",
	Description = "",
	Default = ""
}, function(value)
	print(value);
end);

CCSection1:Keybind({
	Title = "Kill All",
	Description = "",
	Default = Enum.KeyCode.Q
}, function(value)
	print(value);
end);

-- Visuals Category

-- Misc Category

-- Settings Category
SCSection1:Button({
	Title = "Unload",
	ButtonName = "Unload",
	Description = "Unloads Cheats"
}, function(value)
	UILib:Unload()
	isInjected = false
   
end);