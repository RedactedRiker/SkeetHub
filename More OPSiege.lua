local breachFolder = game.Workspace:FindFirstChild("SE_Workspace") and game.Workspace.SE_Workspace:FindFirstChild("Breach")
local baraFolder = game.Workspace:FindFirstChild("SE_Workspace") and game.Workspace.SE_Workspace:FindFirstChild("Doors")

if not baraFolder then
    warn("Barricade folder not found.")
    return
end

if not breachFolder then
    warn("Breach folder not found.")
    return
end

function AutoDetect()
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


local function modifyChargeParts(destroyableWall)
    if destroyableWall:IsA("Model") then
        for _, destroyable in ipairs(destroyableWall:GetChildren()) do
            if destroyable:IsA("Model") then
                for _, charge in ipairs(destroyable:GetChildren()) do
                        charge.CanCollide = false
                        charge.CanQuery = true
                        charge.Transparency = 0.95
                end
            end
        end
    end
end


while true do 
    for _, descendant in ipairs(breachFolder:GetDescendants()) do
        modifyChargeParts(descendant)
    end

    for _, descendant in ipairs(baraFolder:GetDescendants()) do 
        for _, descendant in ipairs(descendant:GetDescendants()) do 
            
        end
    end


    AutoDetect()

    task.wait(1)
end 

print("Finished modifying all 'Charge' parts in 'Destroyable' models under 'DestroyableWall' in 'Breach'.")
