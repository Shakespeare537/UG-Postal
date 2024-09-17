Config = {}

Config.Framework = "newesx"
Config.Command = "postal"

Config.Blip = {
    text = "Postal Route %s",
    sprite = 8,
    color = 3,
}

Config.Locale = {
    -- chat:addSuggestion
    ["POSTAL_COMMAND"] = {
        command = "/postal",
        description = "Postal code to setup GPS blip",
        name = "Postal Number",
        helptext = "Text postal number for getting waypoint"
    },
    -- Notify
    ["POSTAL_REMOVED"] = {
        text = "You are removed Postal",
        time = 5000,
        type = "success"
    },
    ["SETUP_POSTAL"] = {
        text = "You Setup Postal %s to your GPS",
        time = 5000,
        type = "info"
    },
    ["POSTAL_NOT_FOUND"] = {
        text = "Postal not found!",
        time = 5000,
        type = "error"
    }
}

Config.ClientNotification = function(msg, time, type)
    if Config.Framework == "newesx" or Config.Framework == "oldesx" then
        TriggerEvent("esx:showNotification", msg, type)
    else
        TriggerEvent("QBCore:Notify", msg, type)
    end
end
