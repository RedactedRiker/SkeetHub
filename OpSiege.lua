-- loadstring(game:HttpGet("https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/BypassedDarkDexV3.lua", true))()
-- wait()
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/Turtle-Brand/Turtle-Spy/main/source.lua", true))()
-- wait()
-- loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
-- // Libs
local ESPLib = loadstring(game:HttpGet(
                              "https://raw.githubusercontent.com/Blissful4992/ESPs/main/UniversalSkeleton.lua"))()

local UserInputService = game:GetService("UserInputService")
local dronesPath = game.Workspace.SE_Workspace.Drones

local dronesESP = {}
local Skeletons = {}
local isInjected = true
local unInjectKey = Enum.KeyCode.Delete

local box = Drawing.new("Square")
box.Position = Vector2.new(50, 50)
box.Size = Vector2.new(100, 100)
box.Color = Color3.new(1, 1, 0)
box.Filled = true

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
        else
            if descendant:IsA("Model") and descendant.Name == "Reinforced" then
                local reinforcePart =
                    descendant:FindFirstChild("ReinforcedWall")
                reinforcePart.CanQuery = false
                reinforcePart.CanCollide = false
                reinforcePart.Transparency = 1
            end
        end
    end
end

function teleportToBomb()
    local path = game.Workspace.Objective:GetDescendants("Bomb_A", "Bomb_B")
end

function modifyBarricades(opacity)
    for _, descendant in ipairs(baraFolder:GetDescendants()) do
        for _, descendant in ipairs(descendant:GetDescendants()) do
            if descendant:IsA("Part") then
                for _, descendant in ipairs(descendant:GetDescendants()) do
                    if descendant:IsA("Part") then
                        descendant.CanCollide = false
                        descendant.CanQuery = true
                        descendant.Transparency = opacity
                    end
                end
            end
        end
    end
end

-- // ESP
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
function removeAllSkeletons()
    for _, skeleton in ipairs(Skeletons) do skeleton:Remove() end
    Skeletons = {}
end

function createDroneESP()
    local droneHighlight = Instance.new("Highlight")
    if not dronesPath then
        warn("Drones folder not found.")
        return
    end

    for i, v in pairs(dronesPath) do
        if v:IsA(Model) and v.Name == "Drone" then 
            droneHighlight.Parent = v.Drone 
        end
    end
end

function removeAllDroneESP()
    for _, billboardGui in ipairs(dronesESP) do
        if billboardGui and billboardGui.Parent then
            billboardGui:Destroy()
        end
    end
    dronesESP = {}
end

-- // Core
function hackLoop()
    while isInjected do
        modifyWallParts(0.7)
        modifyBarricades(0.7)
        createDroneESP()
        DetectOperators()
        task.wait(1)
    end
end

function coreLoop()
    while isInjected do
        if UserInputService:IsKeyDown(unInjectKey) then
            box:Destroy()
            isInjected = false
            removeAllSkeletons()
        end
        task.wait()
    end
end

function Init()
    createSkeletons()

    local wrap1 = coroutine.wrap(hackLoop)
    local wrap2 = coroutine.wrap(coreLoop)

    wrap1()
    wrap2()
end

if isInjected then Init() end
