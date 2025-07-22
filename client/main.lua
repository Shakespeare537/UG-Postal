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
            Config.ClientNotification(Config.Locale["POSTAL_REMOVED"].text, Config.Locale["POSTAL_REMOVED"].time, Config.Locale["POSTAL_REMOVED"].type)
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

        local coords = vector3(foundPostal[1][1], foundPostal[1][2], 0.0)
        local blip = AddBlipForCoord(coords)

        pBlip = { hndl = blip, p = foundPostal }

        SetBlipSprite(blip, Config.Blip.sprite or 8)
        SetBlipColour(blip, Config.Blip.color or 3)
        SetBlipScale(blip, 1.0)
        SetBlipRoute(blip, true)
        SetBlipRouteColour(blip, Config.Blip.color or 3)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(format(Config.Blip.text or "Cíl: %s", foundPostal.code))
        EndTextCommandSetBlipName(blip)

        Config.ClientNotification(
            Config.Locale["SETUP_POSTAL"].text:format(foundPostal.code),
            Config.Locale["SETUP_POSTAL"].time,
            Config.Locale["SETUP_POSTAL"].type
        )

        CreateThread(function()
            while pBlip do
                Wait(1000)
                local player = PlayerPedId()
                local playerCoords = GetEntityCoords(player)
                if #(playerCoords - coords) <= 25.0 then
                    RemoveBlip(pBlip.hndl)
                    pBlip = nil
                    Config.ClientNotification(Config.Locale["POSTAL_ARRIVE"].text, Config.Locale["POSTAL_ARRIVE"].time, Config.Locale["POSTAL_ARRIVE"].type)
                    break
                end
            end
        end)
    else
        Config.ClientNotification(
            Config.Locale["POSTAL_NOT_FOUND"].text,
            Config.Locale["POSTAL_NOT_FOUND"].time,
            Config.Locale["POSTAL_NOT_FOUND"].type
        )
    end
end)


