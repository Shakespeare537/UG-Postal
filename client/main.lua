postals = nil
Citizen.CreateThread(function()
    postals = LoadResourceFile(GetCurrentResourceName(), GetResourceMetadata(GetCurrentResourceName(), 'postal_file'))
    postals = json.decode(postals)
    for i, postal in ipairs(postals) do postals[i] = { vec(postal.x, postal.y), code = postal.code } end
end)

pBlip = nil

-- optimizations
local ipairs = ipairs
local upper = string.upper
local format = string.format
-- end optimizations

TriggerEvent('chat:addSuggestion', Config.Locale["POSTAL_COMMAND"].command, Config.Locale["POSTAL_COMMAND"].description,
             { { name = Config.Locale["POSTAL_COMMAND"].name, help = Config.Locale["POSTAL_COMMAND"].helptext } })

RegisterCommand(Config.Command, function(_, args)
    if #args < 1 then
        if pBlip then
            RemoveBlip(pBlip.hndl)
            pBlip = nil
            Config.ClientNotification(Config.Locale["POSTAL_REMOVED"].text,Config.Locale["POSTAL_REMOVED"].time,Config.Locale["POSTAL_REMOVED"].type)
        end
        return
    end

    local userPostal = upper(args[1])
    local foundPostal

    for _, p in ipairs(postals) do
        if upper(p.code) == userPostal then
            foundPostal = p
            break
        end
    end

    if foundPostal then
        if pBlip then RemoveBlip(pBlip.hndl) end
        local blip = AddBlipForCoord(foundPostal[1][1], foundPostal[1][2], 0.0)
        pBlip = { hndl = blip, p = foundPostal }
        SetBlipRoute(blip, true)
        SetBlipSprite(blip, Config.Blip.sprite)
        SetBlipColour(blip, Config.Blip.color)
        SetBlipRouteColour(blip, Config.Blip.color)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(format(Config.Blip.text, pBlip.p.code))
        EndTextCommandSetBlipName(blip)
        Config.ClientNotification(Config.Locale["SETUP_POSTAL"].text:format(foundPostal.code),Config.Locale["SETUP_POSTAL"].time,Config.Locale["SETUP_POSTAL"].type)

    else
        Config.ClientNotification(Config.Locale["POSTAL_NOT_FOUND"].text,Config.Locale["POSTAL_NOT_FOUND"].time,Config.Locale["POSTAL_NOT_FOUND"].type)
    end
end)

