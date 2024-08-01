local gameID
local gameName
local scriptLink
local player = game.Players.LocalPlayer

local ScriptLinks = {
    OperationSiege = 'https://raw.githubusercontent.com/RedactedRiker/SkeetHub/main/OpSiege.lua',
}

local GameIds = {
    ["OperationSiege"] = {
        13997018456, -- HUB
        13997264379, -- Casual
        -- Ranked { ID Needed }
    },

    ["RIVALS"] = {
        17625359962,
    },
}

function getGameInfo()
    gameID = game.PlaceId
    local productInfo = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
    gameName = productInfo.Name
    if gameID ~= nil then
        getGameScript()
    end
end

function getGameScript()
    if (gameID == nil) then
        -- warn("No Game Found")
        player:Kick("This game is not supported!")
        return
    end

    local foundGameName = nil

    for name, ids in pairs(GameIds) do
        for _, id in ipairs(ids) do
            if id == gameID then
                foundGameName = name
                break
            end
        end
        if foundGameName then
            break
        end
    end

    if foundGameName then
        print("Game Name: " .. foundGameName)
        scriptLink = ScriptLinks[foundGameName]
        if scriptLink then
            print("Script Link: " .. scriptLink)
            loadScript()
        else
            warn("No Script Link Found for " .. foundGameName)
        end
    else
        warn("Game ID not found in GameIds")
    end
end

function loadScript()
    loadstring(game:HttpGet(scriptLink))()
end

getGameInfo()