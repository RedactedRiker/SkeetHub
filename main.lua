Dronelocal Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/NeverJar/ImpactUI/main/ImpactUI.lua"))()
local Window = Library:Create("SkeetHub", "v1.1")

local Tab1 = Window:Tab1("Aimbot", true)
local Tab2 = Window:Tab1("Visuals", true)
local Tab3 = Window:Tab1("Misc", true)
local Tab4 = Window:Tab1("Settings", true)
--[[
  NAME: STRING
  VISIBILITY: BOOLEAN
]]
Tab1:Label("TEXT")

--[[
  TEXT: STRING
]]
Tab1:Textbox("Name", "Placeholder", function(txt)
    -- Code here
end)

--[[
  NAME: STRING
  PLACEHOLDER: STRING
]]

Tab1:Keybind("Keybind Name", Enum.KeyCode.G, function()
    -- Code here
end)

Tab1:Dropdown("Dropdow Name", {"Option 1", "Option 2", "Option 3"}, function(current)
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

Tab1:Slider("Slider Name", 16, 500, function(value)
    -- Code here
end)

--[[
  NAME: STRING
  MIN-VALUE: INT
  MAX-VALUE: INT
]]