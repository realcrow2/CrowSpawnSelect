-- Main client script for spawn selector

-- Resource name protection - must be named exactly "CrowSpawnSelect"
local resourceName = GetCurrentResourceName()
if resourceName ~= "CrowSpawnSelect" then
    print("^1[ERROR] This resource must be named exactly 'CrowSpawnSelect' to function properly.^0")
    print("^1[ERROR] Current resource name: '" .. resourceName .. "'^0")
    print("^1[ERROR] Please rename the resource folder to 'CrowSpawnSelect' and restart the resource.^0")
    return
end

local NUI_status = false

-- Function to open the spawn select UI
function OpenSpawnSelectUI(coords)
    if NUI_status then 
        print("^3[crow_spawnselect] UI already open, ignoring request^0")
        return 
    end
    
    print("^2[crow_spawnselect] Opening spawn selector UI^0")
    NUI_status = true
    
    -- Get current time for day/night mode
    local currentHour = GetClockHours()
    
    -- Get player data for job/last position
    local playerData = {
        last = nil,
        job = nil,
        personal = nil,
        time = currentHour,
        dayhours = Config.DayHours
    }
    
    -- Request player data from server
    TriggerServerEvent('crow_spawnselect:GetPlayerData')
    
    -- Wait for NUI to be ready - give it time to load
    Citizen.Wait(1500)
    
    -- Send UI data to NUI to show it
    print("^2[crow_spawnselect] Sending open message to NUI^0")
    SendNUIMessage({
        type = 'open',
        data = playerData
    })
    
    -- Send it again after a short delay to ensure it's received
    Citizen.Wait(500)
    SendNUIMessage({
        type = 'open',
        data = playerData
    })
    
    -- Wait a bit more then enable focus
    Citizen.Wait(300)
    SetNuiFocus(true, true)
    print("^2[crow_spawnselect] NUI Focus enabled^0")
end

-- Handle spawn button click from NUI
RegisterNUICallback('spawn', function(data, cb)
    if data and data.name then
        -- Find the spawn location in config
        local spawnCoords = Config.MainSpawns[data.name]
        
        if spawnCoords then
            -- Close NUI
            SetNuiFocus(false, false)
            NUI_status = false
            SendNUIMessage({
                type = 'close'
            })
            
            -- Request spawn from server
            TriggerServerEvent('crow_spawnselect:SpawnPlayer', spawnCoords)
            cb('ok')
        else
            cb('error')
        end
    else
        cb('error')
    end
end)

-- Handle last position button
RegisterNUICallback('lastPosition', function(data, cb)
    TriggerServerEvent('crow_spawnselect:GetLastPosition')
    cb('ok')
end)

-- Handle job position button
RegisterNUICallback('jobPosition', function(data, cb)
    local jobName = GetJob()
    if jobName and Config.JobSpawnsCoords[jobName] then
        local spawnCoords = Config.JobSpawnsCoords[jobName]
        
        SetNuiFocus(false, false)
        NUI_status = false
        SendNUIMessage({
            type = 'close'
        })
        
        TriggerServerEvent('crow_spawnselect:SpawnPlayer', spawnCoords)
        cb('ok')
    else
        cb('error')
    end
end)

-- Handle custom position button
RegisterNUICallback('customPosition', function(data, cb)
    TriggerServerEvent('crow_spawnselect:GetCustomPosition')
    cb('ok')
end)

-- Handle NUI ready callback
RegisterNUICallback('ready', function(data, cb)
    cb('ok')
end)

-- Handle day hours change
RegisterNUICallback('changeDayHours', function(data, cb)
    cb('ok')
end)

-- Event to receive player data from server
RegisterNetEvent('crow_spawnselect:ReceivePlayerData')
AddEventHandler('crow_spawnselect:ReceivePlayerData', function(playerData)
    SendNUIMessage({
        type = 'updateData',
        data = playerData
    })
end)

-- Event to spawn at last position
RegisterNetEvent('crow_spawnselect:SpawnAtLastPosition')
AddEventHandler('crow_spawnselect:SpawnAtLastPosition', function(coords)
    if coords then
        SetNuiFocus(false, false)
        NUI_status = false
        SendNUIMessage({
            type = 'close'
        })
        
        TriggerServerEvent('crow_spawnselect:SpawnPlayer', coords)
    end
end)

-- Event to spawn at custom position
RegisterNetEvent('crow_spawnselect:SpawnAtCustomPosition')
AddEventHandler('crow_spawnselect:SpawnAtCustomPosition', function(coords)
    if coords then
        SetNuiFocus(false, false)
        NUI_status = false
        SendNUIMessage({
            type = 'close'
        })
        
        TriggerServerEvent('crow_spawnselect:SpawnPlayer', coords)
    end
end)

-- Event to spawn player
RegisterNetEvent('crow_spawnselect:DoSpawn')
AddEventHandler('crow_spawnselect:DoSpawn', function(coords)
    HasFullySpawnedIn(coords)
end)

-- Handle escape key to close UI (optional, can be disabled)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if NUI_status then
            DisableControlAction(0, 1, true) -- LookLeftRight
            DisableControlAction(0, 2, true) -- LookUpDown
            DisableControlAction(0, 142, true) -- MeleeAttackAlternate
            DisableControlAction(0, 18, true) -- Enter
            DisableControlAction(0, 322, true) -- ESC
            DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
        end
    end
end)

