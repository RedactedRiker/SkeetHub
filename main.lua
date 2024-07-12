local Library = loadstring(game:HttpGet(
                               "https://raw.githubusercontent.com/NeverJar/ImpactUI/main/ImpactUI.lua"))()
local Window = Library:Create("SkeetHub", "v1.1")
local menuKey = Enum.KeyCode.Insert

local UserInputService = game:GetService("UserInputService")

local Tab1 = Window:Tab("Aimbot", true)
local Tab2 = Window:Tab("Visuals", true)
local Tab3 = Window:Tab("Misc", true)
local Tab4 = Window:Tab("Settings", true)
--[[
  NAME: STRING
  VISIBILITY: BOOLEAN
]]
Tab1:Label("TEXT")

--[[
  TEXT: STRING
]]
Tab1:Textbox("Name", "Placeholder", function(txt)
    -- Code here0
end)

--[[
  NAME: STRING
  PLACEHOLDER: STRING
]]

Tab1:Keybind("Keybind Name", Enum.KeyCode.RightShift, function()
    -- Code here
end)

Tab1:Dropdown("Dropdow Name", {"Option 1", "Option 2", "Option 3"},
              function(current)
    -- Code here
end)

--[[
  NAME: STRING
  OPTIONS: STRING LIST
]]

Tab1:Toggle("Toggle Name", function(bool)
    -- Code here
end)

--[[
  NAME: STRING
]]

Tab1:Slider("Slider Name", 0, 100, function(value)
    -- Code here
end)

--[[
  NAME: STRING
  MIN-VALUE: INT
  MAX-VALUE: INT
]]



--// Extra

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if not gameProcessedEvent and input.KeyCode == menuKey then
        Window.Visible = not Window.Visible
    end
end)