loadstring(game:HttpGet("https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/BypassedDarkDexV3.lua", true))()
task.wait()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Turtle-Brand/Turtle-Spy/main/source.lua", true))()
task.wait()
loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()

local isInjected = true

local UserInputService = game:GetService("UserInputService")

local unInjectKey = Enum.KeyCode.Delete

local box = Drawing.new("Square")
box.Position = Vector2.new(500, 500) -- Position at the top left corner
box.Size = Vector2.new(100, 100) -- Width and Height of the box
box.Color = Color3.new(1, 0, 0)
box.Filled = true

print("Injecting... (".. os.clock() ..")")

while isInjected do
    if UserInputService:IsKeyDown(unInjectKey) then
        print("Uninjecting (" .. os.clock() .. ")")
        isInjected = false
        box:Remove()
    end

    task.wait()
end
