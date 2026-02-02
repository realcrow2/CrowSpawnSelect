--███████╗██████╗  █████╗ ███╗   ███╗███████╗██╗    ██╗ ██████╗ ██████╗ ██╗  ██╗
--██╔════╝██╔══██╗██╔══██╗████╗ ████║██╔════╝██║    ██║██╔═══██╗██╔══██╗██║ ██╔╝
--█████╗  ██████╔╝███████║██╔████╔██║█████╗  ██║ █╗ ██║██║   ██║██████╔╝█████╔╝ 
--██╔══╝  ██╔══██╗██╔══██║██║╚██╔╝██║██╔══╝  ██║███╗██║██║   ██║██╔══██╗██╔═██╗ 
--██║     ██║  ██║██║  ██║██║ ╚═╝ ██║███████╗╚███╔███╔╝╚██████╔╝██║  ██║██║  ██╗
--╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝ ╚══╝╚══╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝


ESX, QBCore = nil, nil

Citizen.CreateThread(function()
    if Config.Framework == 'esx' then
        while ESX == nil do
            pcall(function() ESX = exports[Config.FrameworkTriggers.resource_name]:getSharedObject() end)
            if ESX == nil then
                TriggerEvent(Config.FrameworkTriggers.main, function(obj) ESX = obj end)
            end
            Citizen.Wait(100)
        end

        RegisterNetEvent(Config.FrameworkTriggers.load)
        AddEventHandler(Config.FrameworkTriggers.load, function(xPlayer)
            if GetResourceState('cd_multicharacter') ~= 'started' and GetResourceState('cd_identity') ~= 'started' then
                DoScreenFadeOut(0)
                ESX.TriggerServerCallback('crow_spawnselect:CheckIfNew', function(is_new)
                    if not is_new then
                        Citizen.Wait(2000)
                        TriggerEvent('crow_spawnselect:OpenUI')
                    end
                end)
            end
            ESX.PlayerData = xPlayer
        end)

        RegisterNetEvent(Config.FrameworkTriggers.job)
        AddEventHandler(Config.FrameworkTriggers.job, function(job)
            ESX.PlayerData.job = job
        end)
    
    elseif Config.Framework == 'qbcore' then
        while QBCore == nil do
            TriggerEvent(Config.FrameworkTriggers.main, function(obj) QBCore = obj end)
            if QBCore == nil then
                QBCore = exports[Config.FrameworkTriggers.resource_name]:GetCoreObject()
            end
            Citizen.Wait(100)
        end

        RegisterNetEvent(Config.FrameworkTriggers.load)
        AddEventHandler(Config.FrameworkTriggers.load, function()

        end)

        RegisterNetEvent(Config.FrameworkTriggers.job)
        AddEventHandler(Config.FrameworkTriggers.job, function(JobInfo)
            QBCore.Functions.GetPlayerData().job = JobInfo
        end)

        RegisterNetEvent('qb-spawn:client:openUI')
        AddEventHandler('qb-spawn:client:openUI', function()
            DoScreenFadeOut(0)
            Citizen.Wait(2000)
            TriggerEvent('crow_spawnselect:OpenUI')
        end)
    
    elseif Config.Framework == 'vrp' or Config.Framework == 'none' then
        -- For standalone/vMenu servers, show spawn selector immediately when player joins
        local hasShownSpawn = false
        
        -- Simple method: Wait a fixed time after resource starts, then show UI
        Citizen.CreateThread(function()
            -- Wait for session to be active
            while not NetworkIsSessionStarted() do
                Citizen.Wait(100)
            end
            
            -- Wait for player to exist
            local attempts = 0
            while not DoesEntityExist(PlayerPedId()) and attempts < 50 do
                Citizen.Wait(200)
                attempts = attempts + 1
            end
            
            -- Wait additional time for everything to load
            Citizen.Wait(5000)
            
            if not hasShownSpawn then
                hasShownSpawn = true
                print("^2[crow_spawnselect] Opening spawn selector UI^0")
                
                -- Fade out screen
                DoScreenFadeOut(0)
                Citizen.Wait(1000)
                
                -- Open the spawn selector
                TriggerEvent('crow_spawnselect:OpenUI')
            end
        end)
        
        -- Backup: Listen for player spawning event
        AddEventHandler('playerSpawned', function()
            Citizen.Wait(2000)
            if not hasShownSpawn then
                hasShownSpawn = true
                print("^2[crow_spawnselect] Player spawned, opening spawn selector...^0")
                DoScreenFadeOut(0)
                Citizen.Wait(1000)
                TriggerEvent('crow_spawnselect:OpenUI')
            end
        end)

        
    elseif Config.Framework == 'other' then
        --add your framework code here.

    end
end)

function GetJob()
    if Config.Framework == 'esx' then
        while ESX.PlayerData == nil or ESX.PlayerData.job == nil or ESX.PlayerData.job.name == nil do
            Citizen.Wait(0)
        end
        return ESX.PlayerData.job.name or 'unemployed'
    
    elseif Config.Framework == 'qbcore' then
        while QBCore.Functions.GetPlayerData() == nil or QBCore.Functions.GetPlayerData().job == nil or QBCore.Functions.GetPlayerData().job.name == nil do
            Citizen.Wait(0)
        end
        return QBCore.Functions.GetPlayerData().job.name or 'unemployed'

    elseif Config.Framework == 'vrp' or Config.Framework == 'none' then
        return 'unemployed'

    elseif Config.Framework == 'other' then
        return 'unemployed' --return a players job name (string).
    end
end


--███╗   ███╗ █████╗ ██╗███╗   ██╗
--████╗ ████║██╔══██╗██║████╗  ██║
--██╔████╔██║███████║██║██╔██╗ ██║
--██║╚██╔╝██║██╔══██║██║██║╚██╗██║
--██║ ╚═╝ ██║██║  ██║██║██║ ╚████║
--╚═╝     ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝


RegisterNetEvent('crow_spawnselect:OpenUI')
AddEventHandler('crow_spawnselect:OpenUI', function(coords)
    OpenSpawnSelectUI(coords)
end)

-- Flag to prevent double execution
local isSpawning = false

function HasFullySpawnedIn(coords) --coords: your chosen spawn location (in a table format {x,y,z,h} ).
    -- Prevent double execution
    if isSpawning then
        print("^3[crow_spawnselect] Spawn already in progress, ignoring duplicate call^0")
        return
    end
    
    isSpawning = true
    
    local ped = PlayerPedId()
    
    -- Quick fade out
    DoScreenFadeOut(300)
    Citizen.Wait(300)
    
    -- Wait for collision to load (with timeout)
    RequestCollisionAtCoord(coords.x, coords.y, coords.z)
    local collisionAttempts = 0
    while not HasCollisionLoadedAroundEntity(ped) and collisionAttempts < 100 do 
        RequestCollisionAtCoord(coords.x, coords.y, coords.z) 
        Citizen.Wait(1)
        collisionAttempts = collisionAttempts + 1
    end
    
    -- Set player position and make invisible/frozen BEFORE camera starts
    SetEntityCoords(ped, coords.x, coords.y, coords.z)
    SetEntityHeading(ped, coords.h)
    FreezeEntityPosition(ped, true)
    SetEntityVisible(ped, false, 0)
    SetPlayerInvincible(ped, true)
    SetPlayerInvisibleLocally(ped, true)
    
    -- Disable HUD during cutscene
    DisplayHud(false)
    DisplayRadar(false)
    
    -- Run the camera cutscene (this function will wait for completion)
    HandleCam(coords)
    
    -- Quick wait to ensure cameras are fully disabled
    Citizen.Wait(200)
    
    -- Re-enable player after cutscene
    ped = PlayerPedId()
    FreezeEntityPosition(ped, false)
    SetEntityVisible(ped, true, 0)
    SetPlayerInvincible(ped, false)
    SetPlayerInvisibleLocally(ped, false)
    
    -- Re-enable HUD
    DisplayHud(true)
    DisplayRadar(true)
    
    -- Ensure player is visible and positioned correctly
    local visible = IsEntityVisible(ped)
    if not visible then
        SetEntityVisible(ped, true, 0)
        FreezeEntityPosition(ped, false)
        SetEntityCoords(ped, coords.x, coords.y, coords.z)
        SetEntityHeading(ped, coords.h)
    end
    
    -- Quick fade in
    DoScreenFadeIn(500)
    
    -- Reset flag after a short delay
    Citizen.Wait(500)
    isSpawning = false
    
    if Config.Framework == 'qbcore' then
        TriggerServerEvent('QBCore:Server:OnPlayerLoaded')
        TriggerEvent('QBCore:Client:OnPlayerLoaded')
    end
    ------------------------------------------------------------------------------------------------------
    --Add any trigger events here.

    ------------------------------------------------------------------------------------------------------
end


-- ██████╗██╗  ██╗ █████╗ ████████╗     ██████╗ ██████╗ ███╗   ███╗███╗   ███╗ █████╗ ███╗   ██╗██████╗ ███████╗
--██╔════╝██║  ██║██╔══██╗╚══██╔══╝    ██╔════╝██╔═══██╗████╗ ████║████╗ ████║██╔══██╗████╗  ██║██╔══██╗██╔════╝
--██║     ███████║███████║   ██║       ██║     ██║   ██║██╔████╔██║██╔████╔██║███████║██╔██╗ ██║██║  ██║███████╗
--██║     ██╔══██║██╔══██║   ██║       ██║     ██║   ██║██║╚██╔╝██║██║╚██╔╝██║██╔══██║██║╚██╗██║██║  ██║╚════██║
--╚██████╗██║  ██║██║  ██║   ██║       ╚██████╗╚██████╔╝██║ ╚═╝ ██║██║ ╚═╝ ██║██║  ██║██║ ╚████║██████╔╝███████║
-- ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝        ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝ ╚══════╝


if Config.SpawnOptions.personal then
    TriggerEvent('chat:addSuggestion', '/'..Config.SpawnOptions.personal_command, 'Customise and choose a personal spawn location', {{ name="action", help='[show / set / delete]'}, { name="name", help='Enter the name of your chosen spawn location'}})
    RegisterCommand(Config.SpawnOptions.personal_command, function(source, args)
        local action = args[1]
        local name = args[2]

        if action then
            if action == 'show' then
                TriggerServerEvent('crow_spawnselect:Command', action)

            elseif action == 'set' then
                if name then
                    if #name <= 10 then
                        local ped = PlayerPedId()
                        local coords = GetEntityCoords(ped)
                        local heading = GetEntityHeading(ped)
                        local personal_spawn = {x = round(coords.x), y = round(coords.y), z = round(coords.z), h = round(heading), name = name}
                        TriggerServerEvent('crow_spawnselect:Command', action, personal_spawn)
                    else
                        Notif(3, 'command_maxchars')
                    end
                else
                    Notif(3, 'command_choosename', Config.SpawnOptions.personal_command)
                end

            elseif action == 'delete' then
                TriggerServerEvent('crow_spawnselect:Command', action)
            else
                Notif(3, 'command_invalidformat', Config.SpawnOptions.personal_command)
            end
        else
            Notif(3, 'command_invalidformat', Config.SpawnOptions.personal_command)
        end
    end)
end

if Config.EnableTestCommand then
    RegisterCommand('openspawnselect', function()
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        TriggerEvent('crow_spawnselect:OpenUI', coords)
    end)
end


--███╗   ██╗ ██████╗ ████████╗██╗███████╗██╗ ██████╗ █████╗ ████████╗██╗ ██████╗ ███╗   ██╗███████╗
--████╗  ██║██╔═══██╗╚══██╔══╝██║██╔════╝██║██╔════╝██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║██╔════╝
--██╔██╗ ██║██║   ██║   ██║   ██║█████╗  ██║██║     ███████║   ██║   ██║██║   ██║██╔██╗ ██║███████╗
--██║╚██╗██║██║   ██║   ██║   ██║██╔══╝  ██║██║     ██╔══██║   ██║   ██║██║   ██║██║╚██╗██║╚════██║
--██║ ╚████║╚██████╔╝   ██║   ██║██║     ██║╚██████╗██║  ██║   ██║   ██║╚██████╔╝██║ ╚████║███████║
--╚═╝  ╚═══╝ ╚═════╝    ╚═╝   ╚═╝╚═╝     ╚═╝ ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝


function Notification(notif_type, message)
    if notif_type and message then
        if Config.NotificationType.client == 'esx' then
            ESX.ShowNotification(message)
        
        elseif Config.NotificationType.client == 'qbcore' then
            if notif_type == 1 then
                QBCore.Functions.Notify(message, 'success')
            elseif notif_type == 2 then
                QBCore.Functions.Notify(message, 'primary')
            elseif notif_type == 3 then
                QBCore.Functions.Notify(message, 'error')
            end

        elseif Config.NotificationType.client == 'mythic_old' then
            if notif_type == 1 then
                exports['mythic_notify']:DoCustomHudText('success', message, 10000)
            elseif notif_type == 2 then
                exports['mythic_notify']:DoCustomHudText('inform', message, 10000)
            elseif notif_type == 3 then
                exports['mythic_notify']:DoCustomHudText('error', message, 10000)
            end

        elseif Config.NotificationType.client == 'mythic_new' then
            if notif_type == 1 then
                exports['mythic_notify']:SendAlert('success', message, { ['background-color'] = '#ffffff', ['color'] = '#000000' })
            elseif notif_type == 2 then
                exports['mythic_notify']:SendAlert('inform', message, { ['background-color'] = '#ffffff', ['color'] = '#000000' })
            elseif notif_type == 3 then
                exports['mythic_notify']:SendAlert('error', message, { ['background-color'] = '#ffffff', ['color'] = '#000000' })
            end

        elseif Config.NotificationType.client == 'chat' then
            TriggerEvent('chatMessage', message)
            
        elseif Config.NotificationType.client == 'other' then
            --add your own notification.
            
        end
    end
end

function Notif(notif_type, locale, ...)
    local message = string.format(L(locale), ...)
    Notification(notif_type, message)
end

