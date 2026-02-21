local pedModel = `s_m_y_construct_02`
local pedCoords = vec4(-162.64, -2130.65, 16.71, 195.92)

local kartSpawn = vec4(-117.33, -2117.34, 16.71, 105.33)
local rentedKart = nil

-- TOURS
local totalLaps = 0
local currentLaps = 0
local lapCheckpoint = vec3(-118.98, -2117.91, 16.71)
local lapRadius = 8.0
local canCountLap = true

CreateThread(function()
    -- BLIP
    local blip = AddBlipForCoord(pedCoords.x, pedCoords.y, pedCoords.z)
    SetBlipSprite(blip, 546)
    SetBlipDisplay(blip, 47)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 5)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Game Karting")
    EndTextCommandSetBlipName(blip)

    -- PED
    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do Wait(0) end

    local ped = CreatePed(
        0,
        pedModel,
        pedCoords.x, pedCoords.y, pedCoords.z - 1.0,
        pedCoords.w,
        false,
        true
    )

    SetEntityInvincible(ped, true)
    FreezeEntityPosition(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)

    exports.ox_target:addLocalEntity(ped, {
        {
            label = 'Menu Karting',
            icon = 'fa-solid fa-flag-checkered',
            onSelect = function()
                openKartMenu()
            end
        }
    })
end)

-- MENU UNIQUE
function openKartMenu()
    lib.registerContext({
        id = 'kart_menu',
        title = 'Choix des kart',
        options = {
            {
                title = '15 minutes 5 tours',
                description = 'Kart1 | 500$',
                onSelect = function()
                    startRental('kart3', 6, 500)
                end
            },
            {
                title = '20 minutes 12 tours',
                description = 'Kart2 | 700$',
                onSelect = function()
                    startRental('kart3', tonumber(13), 700)
                end
            },
            {
                title = '30 minutes 20 tours',
                description = 'Kart3 | 1000$',
                onSelect = function()
                    startRental('kart3', tonumber(21), 1000)
                end
            }
        }
    })

    lib.showContext('kart_menu')
end

function startRental(model, laps, price)
    TriggerServerEvent('karting:rent', model, price, laps)
end

-- SPAWN KART
RegisterNetEvent('karting:spawnKart', function(model, laps)
    laps = tonumber(laps) -- forcer type number
    totalLaps = laps
    currentLaps = 0
    canCountLap = true

    local hash = joaat(model)
    RequestModel(hash)
    while not HasModelLoaded(hash) do Wait(0) end

    rentedKart = CreateVehicle(
        hash,
        kartSpawn.x, kartSpawn.y, kartSpawn.z,
        kartSpawn.w,
        true,
        false
    )

    SetVehicleDirtLevel(rentedKart, 15.0)
    SetVehicleFuelLevel(rentedKart, 100.0)
    DecorSetFloat(rentedKart, "_FUEL_LEVEL", 100.0)
    SetVehicleEngineOn(rentedKart, true, true)
    TaskWarpPedIntoVehicle(PlayerPedId(), rentedKart, -1)

    lib.notify({
        title = 'Karting',
        description = 'Objectif : '..totalLaps..' tours',
        type = 'success',
        position = "top-center"
    })

    startLapCounter()
end)

function startLapCounter()
    CreateThread(function()
        while rentedKart and DoesEntityExist(rentedKart) do
            Wait(400)

            local ped = PlayerPedId()
            if GetVehiclePedIsIn(ped, false) ~= rentedKart then return end

            local coords = GetEntityCoords(ped)
            local dist = #(coords - lapCheckpoint)

            if dist < lapRadius and canCountLap then
                canCountLap = false
                currentLaps += 1

                local remaining = totalLaps - currentLaps

                if remaining > 0 then
                    lib.notify({
                        title = 'Tour valide',
                        description = 'Il te reste '..remaining..' tour(s)',
                        type = 'info',
                        position = "top-center"
                    })
                else
                    lib.notify({
                        title = 'Dernier tour',
                        description = 'Course terminee !',
                        type = 'success',
                        position = "top-center"
                    })
                end

                if currentLaps >= totalLaps then
                    finishKarting()
                    return
                end
            end

            if dist > lapRadius + 5.0 then
                canCountLap = true
            end
        end
    end)
end

function finishKarting()
    if rentedKart and DoesEntityExist(rentedKart) then
        DeleteEntity(rentedKart)
        rentedKart = nil
    end

    lib.notify({
        title = 'Karting',
        description = 'Kart rendu, merci et à bientot !',
        type = 'success',
        position = "top-center"
    })
end 