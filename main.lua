local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/RedactedRiker/SkeetHub/main/library.lua?token=GHSAT0AAAAAACUPKRS42Q7ELN2CGJFTO62OZUQ3QXA", true))()
local notif = loadstring(game:HttpGet("https://github.com/RedactedRiker/SkeetHub/blob/main/noti_library.lua"))()

local Aimbot = library:AddWindow('Aimbot')
local Visuals = library:AddWindow('Visuals')
local Misc = library:AddWindow('Misc')
local Settings = library:AddWindow('Settings')
local watermark = library:AddWatermark('');


local e = Aimbot:AddSection('All features')

e:AddLabel('Template Label') 
-- to make a label you do AddLabel('')

e:AddButton('Test button',false,nil, function() 
  print('da button') 
end)

e:AddToggle('Testing Toggle',true,Enum.KeyCode.LeftControl ,function(v) 
    print(v)
  end)

e:AddToggle('Testing Toggle',true,nil, function()
    print("testing toggle toggled")
  end)

-- look below

e:AddSlider('Template Slider', 100, 10, 50,function(c) 
  end)

-- The first (100) is the max
-- The second (10) is the minimum 
-- The third (50) is the default 
-- Works with decimals,
-- Will print the number that u got


local visible = true
e:AddKeyBind('Template Keybind', Enum.KeyCode.Y, function() 
    -- When you will press Y, it's will disable the ui library and the wateramrk
    if watermark:Visible()  then
        watermark:Visible(false) 
        visible = not visible
    else
        watermark:Visible(true) 
        visible = not visible
    end
end)

-- this is for the watermark and ui library keybind


e:AddColorPallete('Testing Color Pallete', Color3.fromRGB(89, 125, 255),function(a) 
  print(a)
  end)
-- Will print the RGB that u choosed

--[[
e:AddTextBox('No filter',nil,false,5,function(a) print(a) end)
-- A textbox with no filter mmeans u can do anything in it.

e:AddTextBox('Only numbers',nil,false,1,function(a) print(a) end)
-- A textbox that you can only place Number in it  no other thing 

e:AddTextBox('No special chars',nil,false,2,function(a) print(a) end)
-- No special thigns like %&@#$%#!@$%@@#^

e:AddTextBox('Only nums+chars',nil,false,3,function(a) print(a) end)
-- only text and number

e:AddTextBox('Only Chars',nil,false,4,function(a) print(a) end)
-- only text 
]]--

e:AddSeparateBar()
-- To add a little bar to separate

e:AddDropdown('Testing Dropdown',{'opt1','opt2','opt3'},'opt2',function(a) print(a) end)

-- Watermark stuff
te:UpdateValue(true)
local ms = library.ms or 'hehe wha'

spawn(function()
    while wait(1) do
        local fps = library.fps
        local t = ''
        if #fps < 2 then
            t = 'FPS: '..'0'..fps..'| MS: '..ms
        else
            t = 'FPS: '..fps..'| MS: '..ms
        end
        watermark:ChangeText('GAY GUYS'..t)
    end
end)


wait(4)



wait(2)
watermark:Visible(true)