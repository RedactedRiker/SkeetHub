local UILib = (loadstring(game:HttpGet("https://raw.githubusercontent.com/RedactedRiker/SkeetHub/main/Dependencies/library.lua")))();
local Window = UILib.new("Operation: Siege", game.Players.LocalPlayer.UserId, "Buyer");

-- Load libraries

print("Loading!")
local ESPLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Blissful4992/ESPs/main/UniversalSkeleton.lua"))()

local UserInputService = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local Skeletons = {}
local isInjected = true
local unInjectKey = Enum.KeyCode.Delete

local showTeamESP = false

local breachFolder = game.Workspace:FindFirstChild("SE_Workspace") and game.Workspace.SE_Workspace:FindFirstChild("Breach")
local baraFolder = game.Workspace:FindFirstChild("SE_Workspace") and game.Workspace.SE_Workspace:FindFirstChild("Doors")

-- HACK TOGGLES / Settings
local modyWalls = true -- These should be false by default and then you can use toggle to enable cuzzo
local modyBarricades = true
local wallOpacity = 0.7
local baraOpacity = 0.7



if not baraFolder then
    warn("Barricade folder not found.")
    isInjected = false
    return
end

if not breachFolder then
    warn("Breach folder not found.")
    isInjected = false
    return
end

-- Detect operators
function DetectOperators()
    for _, player in ipairs(game.Players:GetPlayers()) do
        local playerStats = player:FindFirstChild("playerStats")
        if not playerStats then
            playerStats = Instance.new("Folder")
            playerStats.Name = "PlayerStats"
            playerStats.Parent = player
        end

        local scanValue = playerStats:FindFirstChild("Scan")
        if scanValue then
            scanValue.Value = true
        else
            scanValue = Instance.new("BoolValue")
            scanValue.Name = "Scan"
            scanValue.Value = true
            scanValue.Parent = playerStats
        end
    end
end

-- Modify wall parts
function modifyWallParts(opacity, CanCollide, CanQuery)
    for _, descendant in ipairs(breachFolder:GetDescendants()) do
        if descendant:IsA("Model") and descendant.Name ~= "Reinforced" then

            local isFortified = descendant.Parent:GetDescendants().Fortified

            -- Disable Reinforcements
            if descendant.Parent:GetDescendants().Fortified == true then
                descendant.Parent:GetDescendants().Fortified = false
            end

            if isFortified == true then
                opacity = 1
                print(opacity)
            end

            for _, destroyable in ipairs(descendant:GetChildren()) do
                if destroyable:IsA("Model") then
                    for _, charge in ipairs(destroyable:GetChildren()) do
                        charge.CanCollide = CanCollide
                        charge.CanQuery = CanQuery
                        charge.Transparency = opacity
                    end
                end
            end
        elseif descendant:IsA("Model") and descendant.Name == "Reinforced" then
            local reinforcePart = descendant:FindFirstChild("ReinforcedWall")
            if reinforcePart then
                reinforcePart.CanQuery = false
                reinforcePart.CanCollide = false
                reinforcePart.Transparency = .5
                reinforcePart.Color = Color3.fromRGB(0, 4, 255)
            end
        end
    end
end

-- Tp to bomb
function tpToBomb()
    function tpToBomb(bombName)
        local bomb = game.Workspace.Objective:FindFirstChild(bombName)
        if bomb then
            character:MoveTo(bomb.Center.Position + Vector3.new(0, 5, 0))
        else
            warn(bombName .. " not found in Workspace.Objective!")
        end
    end
end

-- Modify barricades
function modifyBarricades(opacity, CanCollide, CanQuery)
    for _, descendant in ipairs(baraFolder:GetDescendants()) do
        for _, subDescendant in ipairs(descendant:GetDescendants()) do
            if subDescendant:IsA("Part") then
                subDescendant.CanCollide = CanCollide
                subDescendant.CanQuery = CanQuery
                subDescendant.Transparency = opacity
            end
        end
    end
end

-- Create skeletons for all players
function createSkeletons()
    local function addSkeletonForPlayer(Player)
        if Player ~= game.Players.LocalPlayer then
            local showSkeleton = false
            if showTeamESP then
                showSkeleton = true
            else
                if Player.Team ~= game.Players.LocalPlayer.Team then
                    showSkeleton = true
                end
            end
            if showSkeleton then
                local skeleton = ESPLib:NewSkeleton(Player, true)
                table.insert(Skeletons, skeleton)
            end
        end
    end

    for _, Player in ipairs(game.Players:GetPlayers()) do
        addSkeletonForPlayer(Player)
    end

    game.Players.PlayerAdded:Connect(function(Player)
        addSkeletonForPlayer(Player)
    end)
end


-- Remove all skeletons
function removeAllSkeletons()
    for _, skeleton in ipairs(Skeletons) do skeleton:Remove() end
    Skeletons = {}
end

function expandHitbox(character)
    for _, part in ipairs(character:GetChildren()) do
        if part.Name == "Head" then
            part.Size = part.Size * 2
            part.Massless = true
            part.Transparency = 0.5
        end
    end
end

function enabledWallHack()
    modifyWallParts(wallOpacity , false, true)  
end

function disabledWallParts()
    modifyWallParts(0 , true, true) 
end

function enabledBaraHack()
    modifyWallParts(baraOpacity , false, true)  
end

function disabledBaraHack()
    modifyWallParts(0 , true, true) 
end


-- Main hack loop
function hackLoop()
    createSkeletons()
    while isInjected do
        if modyWalls then
            enabledWallHack()
        else 
            disabledWallParts()
        end
        if modyBarricades then
            enabledBaraHack()
        else
            disabledBaraHack()
        end
        
        DetectOperators()
        task.wait(1)
    end
end

-- Core loop for handling user input and cleanup
function coreLoop()
    while isInjected do
        if UserInputService:IsKeyDown(unInjectKey) then
            isInjected = false
            removeAllSkeletons()
            modifyWallParts(0 , true, true) 
            modifyBarricades(0, true, true)
            print("Uninjected!")
        end
        
        task.wait()
    end
end

-- Initialize the script
function Init()
    local wrap1 = coroutine.wrap(hackLoop)
    local wrap2 = coroutine.wrap(coreLoop)

    wrap1()
    wrap2()
end



if isInjected then
    Init()
end


-- UI Inititation

if isInjected then
    
    local CombatCategory = Window:Category("Combat", "http://www.roblox.com/asset/?id=18438759105");
    local VisualsCategory = Window:Category("Visuals", "http://www.roblox.com/asset/?id=18438764404");
    local MiscCategory = Window:Category("Misc", "http://www.roblox.com/asset/?id=18438761439");
    local SettingsCategory = Window:Category("Settings", "http://www.roblox.com/asset/?id=18438766957");

    local CCButton1 = CombatCategory:Button("Rage", "http://www.roblox.com/asset/?id=8395747586");
    local CCButton2 = CombatCategory:Button("Legit", "http://www.roblox.com/asset/?id=8395747586");

    local SCButton1 = SettingsCategory:Button("Main", "http://www.roblox.com/asset/?id=8395747586");

    local CCSection1 = CCButton1:Section("Rage Features", "Left");
    local CCSection2 = CCButton2:Section("Legit Features", "Left");

    local SCSection1 = SCButton1:Section("Unload", "Left");


    -- BUTTON Stuff

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
end