-- Main server script for spawn selector

-- Resource name protection - must be named exactly "CrowSpawnSelect"
local resourceName = GetCurrentResourceName()
if resourceName ~= "CrowSpawnSelect" then
    print("^1[ERROR] This resource must be named exactly 'CrowSpawnSelect' to function properly.^0")
    print("^1[ERROR] Current resource name: '" .. resourceName .. "'^0")
    print("^1[ERROR] Please rename the resource folder to 'CrowSpawnSelect' and restart the resource.^0")
    return
end

-- Event to get player data (last position, job, personal spawn)
RegisterNetEvent('crow_spawnselect:GetPlayerData')
AddEventHandler('crow_spawnselect:GetPlayerData', function()
    local src = source
    local playerData = {
        last = nil,
        job = nil,
        personal = nil,
        time = GetClockHours(),
        dayhours = Config.DayHours
    }
    
    -- For standalone/no framework, we don't have last position or job data
    -- But we can still send the time for day/night mode
    TriggerClientEvent('crow_spawnselect:ReceivePlayerData', src, playerData)
end)

-- Event to spawn player at selected location
RegisterNetEvent('crow_spawnselect:SpawnPlayer')
AddEventHandler('crow_spawnselect:SpawnPlayer', function(coords)
    local src = source
    
    if not coords or not coords.x or not coords.y or not coords.z then
        coords = Config.BuggedSpawnCoords
    end
    
    -- Trigger client to spawn
    TriggerClientEvent('crow_spawnselect:DoSpawn', src, coords)
end)

-- Event to get last position
RegisterNetEvent('crow_spawnselect:GetLastPosition')
AddEventHandler('crow_spawnselect:GetLastPosition', function()
    local src = source
    
    -- For standalone, we don't have last position saved
    -- You can implement database saving if needed
    local lastPos = GetLastPosition(src)
    if lastPos then
        TriggerClientEvent('crow_spawnselect:SpawnAtLastPosition', src, lastPos)
    else
        TriggerClientEvent('crow_spawnselect:SpawnAtLastPosition', src, nil)
    end
end)

-- Event to get custom position
RegisterNetEvent('crow_spawnselect:GetCustomPosition')
AddEventHandler('crow_spawnselect:GetCustomPosition', function()
    local src = source
    
    -- For standalone, we don't have custom position saved
    -- You can implement database saving if needed
    TriggerClientEvent('crow_spawnselect:SpawnAtCustomPosition', src, nil)
end)

