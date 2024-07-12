-- loadstring(game:HttpGet("https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/BypassedDarkDexV3.lua", true))()
-- wait()
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/Turtle-Brand/Turtle-Spy/main/source.lua", true))()
-- wait()
-- loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()

local isInjected = true

local UserInputService = game:GetService("UserInputService")

local unInjectKey = Enum.KeyCode.Delete
local destroyAllWalls = Enum.KeyCode.PageUp

local box = Drawing.new("Square")
box.Position = Vector2.new(50, 50)
box.Size = Vector2.new(100, 100)
box.Color = Color3.new(1, 0, 0)
box.Filled = true

local currentTime = os.time()
local formattedTime = os.date("%I:%M %p", currentTime)

print("Injecting... (" .. formattedTime .. ")")

function getCurrentMap()
    return game.Workspace:FindFirstChild("House") or 
           game.Workspace:FindFirstChild("Fortress") or 
           game.Workspace:FindFirstChild("Amazon") or 
           game.Workspace:FindFirstChild("Chalet") or 
           game.Workspace:FindFirstChild("Mansion") or 
           game.Workspace:FindFirstChild("Office") or 
           game.Workspace:FindFirstChild("Safehouse")
end

function RemoveAllWalls(currentMapPath)
    local WallsFolder
    local currentMapName = currentMapPath.Name

    if currentMapName == "Fortress" then
        WallsFolder = currentMapPath:FindFirstChild("Breach")
    end

    if currentMapName == "House" then
        WallsFolder = currentMapPath:FindFirstChild("SE_Workspace"):FindFirstChild("Breach")
    end


    if WallsFolder then
        WallsFolder:Destroy()
    end
end

function RemoveAllBarricades(currentMap)

end

while isInjected do
    if UserInputService:IsKeyDown(unInjectKey) then
        local currentTime = os.time()
        local formattedTime = os.date("%I:%M %p", currentTime) 

        print("Uninjecting (" .. formattedTime .. ")")
        isInjected = false
        box:Remove()
    end

    if UserInputService:IsKeyDown(destroyAllWalls) then
        local currentMap = getCurrentMap() 
        if currentMap then
            print("Found map: " .. currentMap.Name)
            if currentMap then
                RemoveAllWalls(currentMap)
                RemoveAllBarricades(currentMap) 
            end
        else
            print("No map found.")
        end
    end
    task.wait()
end
