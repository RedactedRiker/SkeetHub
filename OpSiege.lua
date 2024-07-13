-- Load libraries
local ESPLib = loadstring(game:HttpGet(
                              "https://raw.githubusercontent.com/Blissful4992/ESPs/main/UniversalSkeleton.lua"))()
local aimbot = loadstring(game:HttpGet(
                              'https://github.com/RunDTM/Zeerox-Aimbot/raw/main/library.lua'))()

local UserInputService = game:GetService("UserInputService")

local Skeletons = {}
local isInjected = true
local unInjectKey = Enum.KeyCode.Delete
local expandHitbox = true

local box = Drawing.new("Square")
box.Position = Vector2.new(50, 50)
box.Size = Vector2.new(100, 100)
box.Color = Color3.new(1, 1, 0)
box.Filled = true

--[[
local buttonBox = Instance.new("ScreenGui")
local button = Instance.new("TextButton")
buttonBox.Parent = game:GetService("Players").LocalPlayer
button.Parent = buttonBox
button.Position = UDim2.new(0, 10, 0, 50)
button.Color3 = Color3.fromRGB(30, 30, 30)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Text = "Tp to bomb"
]]

local breachFolder = game.Workspace:FindFirstChild("SE_Workspace") and
                         game.Workspace.SE_Workspace:FindFirstChild("Breach")
local baraFolder = game.Workspace:FindFirstChild("SE_Workspace") and
                       game.Workspace.SE_Workspace:FindFirstChild("Doors")

if not baraFolder then
    warn("Barricade folder not found.")
    isInjected = false
    box:Remove()
    return
end

if not breachFolder then
    warn("Breach folder not found.")
    isInjected = false
    box:Remove()
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
function modifyWallParts(opacity)
    for _, descendant in ipairs(breachFolder:GetDescendants()) do
        if descendant:IsA("Model") and descendant.Name ~= "Reinforced" then

            -- Disable Reinforcements
            if descendant.Parent:GetDescendants().Fortified == true then
                descendant.Parent:GetDescendants().Fortified = false
            end

            for _, destroyable in ipairs(descendant:GetChildren()) do
                if destroyable:IsA("Model") then
                    for _, charge in ipairs(destroyable:GetChildren()) do
                        charge.CanCollide = false
                        charge.CanQuery = true
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
                descendant.Transparency = 1
            end
        end
    end
end

-- Tp to bomb ( i mightve cooked with this idk ¯\_(ツ)_/¯ )
function tpToBomb()
    function tpToBomb(bombName)
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()

        local bomb = game.Workspace.Objective:FindFirstChild(bombName)
        if bomb then
            character:MoveTo(bomb.Position + Vector3.fromAxis(0, 5, 0))
        else
            warn(bombName .. " not found in Workspace.Objective!")
        end
    end
end

--[[
button.MouseButton1Click:Connect(function()
    tpToBomb("Bomb_A")
    button:Destroy() -- only for now
end)
]]

-- Modify barricades
function modifyBarricades(opacity)
    for _, descendant in ipairs(baraFolder:GetDescendants()) do
        for _, subDescendant in ipairs(descendant:GetDescendants()) do
            if subDescendant:IsA("Part") then
                subDescendant.CanCollide = false
                subDescendant.CanQuery = true
                subDescendant.Transparency = opacity
            end
        end
    end
end

-- Create skeletons for all players
function createSkeletons()
    for _, Player in ipairs(game.Players:GetPlayers()) do
        if Player ~= game.Players.LocalPlayer then
            local skeleton = ESPLib:NewSkeleton(Player, true)
            table.insert(Skeletons, skeleton)
        end
    end

    game.Players.PlayerAdded:Connect(function(Player)
        if Player ~= game.Players.LocalPlayer then
            local skeleton = ESPLib:NewSkeleton(Player, true)
            table.insert(Skeletons, skeleton)
        end
    end)
end

-- Remove all skeletons
function removeAllSkeletons()
    for _, skeleton in ipairs(Skeletons) do skeleton:Remove() end
    Skeletons = {}
end

--[[
-- Set up aimbot
function AimBot()
    aimbot.Enabled = true -- aimbot enabled
    aimbot.Key = Enum.UserInputType.MouseButton2 -- aimbot key
    aimbot.Smoothing = 20 -- aimbot smoothness
    aimbot.Offset = {0, 0} -- aimbot offset

    aimbot.TeamCheck = true -- team checking enabled
    aimbot.AliveCheck = true -- player alive check

    aimbot.Players = true -- aimbot for default player characters enabled
    aimbot.PlayerPart = 'Head' -- part of default player character to aim
    aimbot.FriendlyPlayers = {'name1', 'name2'} -- whitelisted players

    aimbot.FOV = 200 -- aimbot FOV
    aimbot.FOVCircleColor = Color3.fromRGB(255, 255, 255) -- FOV circle color
    aimbot.ShowFOV = true -- FOV circle visible

    aimbot.CustomParts = {Instance.new('Part', workspace)} -- custom parts for aimbot
end

-- Initialize aimbot
AimBot()
]] --

function expandHitbox()
    if expandHitbox == true then -- For adding this to a button pretty sure the logic would be ( Btn.MouseButton1Click:Connect(function(expandHitbox = true ) end ) i think
        while task.wait(1) do
            for _, v in pairs(game:GetService("Players"):GetPlayers()) do
                if v.Name ~= game:GetService("Players").LocalPlayer.Name then
                    v.Character.Head.CanCollide = false
                    v.Character.Head.Size = Vector3.new(15, 15, 15)
                    v.Character.Head.Transparency = 0.5
                end
            end
        end
    else
        task.wait()
    end
end

-- Main hack loop
function hackLoop()
    while isInjected do
        modifyWallParts(0.7)
        modifyBarricades(0.7)
        DetectOperators()
        task.wait(1)
    end
end

-- Core loop for handling user input and cleanup
function coreLoop()
    while isInjected do
        if UserInputService:IsKeyDown(unInjectKey) then
            box:Destroy()
            isInjected = false
            removeAllSkeletons()
            aimbot.Enabled = false -- Disable aimbot
            aimbot:Destroy() -- Clean up aimbot resources
        end
        task.wait()
    end
end

-- Initialize the script
function Init()
    createSkeletons()

    local wrap1 = coroutine.wrap(hackLoop)
    local wrap2 = coroutine.wrap(coreLoop)

    wrap1()
    wrap2()
end

if isInjected then Init() end
