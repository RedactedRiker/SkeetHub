-- Load libraries
local ESPLib = loadstring(game:HttpGet(
                              "https://raw.githubusercontent.com/Blissful4992/ESPs/main/UniversalSkeleton.lua"))()
local aimbot = loadstring(game:HttpGet(
                              'https://github.com/RunDTM/Zeerox-Aimbot/raw/main/library.lua'))()

local UserInputService = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local Skeletons = {}
local isInjected = true
local unInjectKey = Enum.KeyCode.Delete


--// Design
local box = Drawing.new("Square")
box.Position = Vector2.new(50, 50)
box.Size = Vector2.new(100, 100)
box.Color = Color3.new(1, 1, 0)
box.Filled = true

local buttonBox = Instance.new("ScreenGui")
local tpButton = Instance.new("TextButton")
local hitboxButton = Instance.new("TextButton")

buttonBox.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

tpButton.Parent = buttonBox
tpButton.Position = UDim2.new(0, 10, 0, 50)
tpButton.Size = UDim2.new(0, 75, 0, 25)
tpButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
tpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
tpButton.Text = "Tp to bomb"
tpButton.TextScaled = true

hitboxButton.Parent = buttonBox
hitboxButton.Position = UDim2.new(0, 10, 0, 75)
hitboxButton.Size = UDim2.new(0, 75, 0, 25)
hitboxButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
hitboxButton.TextColor3 = Color3.fromRGB(255, 255, 255)
hitboxButton.Text = "Expand Hitboxes"
hitboxButton.TextScaled = true


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
function modifyWallParts(opacity, CanCollide, CanQuery)
    for _, descendant in ipairs(breachFolder:GetDescendants()) do
        if descendant:IsA("Model") and descendant.Name ~= "Reinforced" then

            -- Disable Reinforcements
            if descendant.Parent:GetDescendants().Fortified == true then
                descendant.Parent:GetDescendants().Fortified = false
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

-- Tp to bomb ( i mightve cooked with this idk ¯\_(ツ)_/¯ )
function tpToBomb()
    function tpToBomb(bombName)
        local bomb = game.Workspace.Objective:FindFirstChild(bombName)
        if bomb then
            character:MoveTo(bomb.Position + Vector3.fromAxis(0, 5, 0))
        else
            warn(bombName .. " not found in Workspace.Objective!")
        end
    end
end

--// Buttons
tpButton.MouseButton1Click:Connect(function()
    tpToBomb("Bomb_A")
    tpButton:Destroy() -- only for now
end)

hitboxButton.MouseButton1Click:Connect(function()
    expandHitbox(character)
end)

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

function expandHitbox(character)
    for _, part in ipairs(character:GetChildren()) do
        if part.Name == "HumanoidRootPart" then
            part.Size = part.Size * 2
            part.Massless = true
            part.Transparency = 0.5
        end
    end
end

-- Main hack loop
function hackLoop()
    while isInjected do
        modifyWallParts(0.7 , false, true) 
        modifyBarricades(0.7, false, true)
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
            modifyWallParts(0 , true, true) 
            modifyBarricades(0, true, true)
            aimbot.Enabled = false 
            aimbot:Destroy()
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
