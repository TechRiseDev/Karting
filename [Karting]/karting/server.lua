ESX = exports['es_extended']:getSharedObject()


local WEBHOOK_URL = "#Lien du webhooks#"

local function SendDiscordLog(title, fields, color)
    PerformHttpRequest(WEBHOOK_URL, function() end, "POST", json.encode({
        username = "Karting Logs",
        embeds = {{
            title = title,
            color = color,
            fields = fields,
            footer = {
                text = os.date("%d/%m/%Y - %H:%M:%S")
            }
        }}
    }), {
        ["Content-Type"] = "application/json"
    })
end


local function GetIdentifiers(source)
    local data = {
        steam = "unknown",
        license = "unknown",
        discord = "unknown"
    }

    for _, id in ipairs(GetPlayerIdentifiers(source)) do
        if id:sub(1,6) == "steam:" then
            data.steam = id
        elseif id:sub(1,8) == "license:" then
            data.license = id
        elseif id:sub(1,8) == "discord:" then
            data.discord = id
        end
    end

    return data
end


RegisterNetEvent('karting:rent', function(model, price, laps)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    laps = tonumber(laps)
    price = tonumber(price)

    local identifiers = GetIdentifiers(src)

    if xPlayer.getMoney() >= price then
        xPlayer.removeMoney(price)


        TriggerClientEvent('karting:spawnKart', src, model, laps)


        SendDiscordLog("Location Kart", {
            { name = "Joueur", value = xPlayer.getName().." (ID "..src..")", inline = false },
            { name = "Kart", value = model, inline = true },
            { name = "Tours", value = tostring(laps), inline = true },
            { name = "Prix", value = price.."$", inline = true },
            {
                name = "Identifiants",
                value =
                    "**Steam :** "..identifiers.steam..
                    "\n**License :** "..identifiers.license..
                    "\n**Discord :** "..identifiers.discord,
                inline = false
            }
        }, 3066993)

    else

        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Karting',
            description = 'Pas assez d\'argent',
            type = 'error',
            position = "top-center"
        })

        -- ?? LOG REFUS
        SendDiscordLog("Location refus�e", {
            { name = "Joueur", value = xPlayer.getName().." (ID "..src..")", inline = false },
            { name = "Raison", value = "Fonds insuffisants", inline = true }
        }, 15158332)
    end
end)


RegisterNetEvent('karting:finish', function(doneLaps, totalLaps)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    local identifiers = GetIdentifiers(src)

    SendDiscordLog("Kart rendu", {
        { name = "Joueur", value = xPlayer.getName().." (ID "..src..")", inline = false },
        { name = "Tours", value = doneLaps.."/"..totalLaps, inline = true },
        {
            name = "Identifiants",
            value =
                "**Steam :** "..identifiers.steam..
                "\n**License :** "..identifiers.license..
                "\n**Discord :** "..identifiers.discord,
            inline = false
        }
    }, 3447003)
end)
