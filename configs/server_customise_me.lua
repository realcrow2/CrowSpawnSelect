--███████╗██████╗  █████╗ ███╗   ███╗███████╗██╗    ██╗ ██████╗ ██████╗ ██╗  ██╗
--██╔════╝██╔══██╗██╔══██╗████╗ ████║██╔════╝██║    ██║██╔═══██╗██╔══██╗██║ ██╔╝
--█████╗  ██████╔╝███████║██╔████╔██║█████╗  ██║ █╗ ██║██║   ██║██████╔╝█████╔╝ 
--██╔══╝  ██╔══██╗██╔══██║██║╚██╔╝██║██╔══╝  ██║███╗██║██║   ██║██╔══██╗██╔═██╗ 
--██║     ██║  ██║██║  ██║██║ ╚═╝ ██║███████╗╚███╔███╔╝╚██████╔╝██║  ██║██║  ██╗
--╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝ ╚══╝╚══╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝


ESX, QBCore = nil, nil

if Config.Framework == 'esx' then
    pcall(function() ESX = exports[Config.FrameworkTriggers.resource_name]:getSharedObject() end)
    if ESX == nil then
        TriggerEvent(Config.FrameworkTriggers.main, function(obj) ESX = obj end)
    end
    
elseif Config.Framework == 'qbcore' then
    TriggerEvent(Config.FrameworkTriggers.main, function(obj) QBCore = obj end)
    if QBCore == nil then
        QBCore = exports[Config.FrameworkTriggers.resource_name]:GetCoreObject()
    end
end

function GetIdentifier(source)
    if Config.Framework == 'esx' then 
        local xPlayer = ESX.GetPlayerFromId(source)
        local timeout=0 while xPlayer==nil and timeout<=30 do Wait(500) xPlayer=ESX.GetPlayerFromId(source) timeout=timeout+1 end
        return xPlayer.identifier

    elseif Config.Framework == 'qbcore' then
        local xPlayer = QBCore.Functions.GetPlayer(source)
        local timeout=0 while xPlayer==nil and timeout<=30 do Wait(500) xPlayer = QBCore.Functions.GetPlayer(source) timeout=timeout+1 end
        return xPlayer.PlayerData.citizenid

    elseif Config.Framework == 'other' then
        return GetPlayerIdentifiers(source)[1] --return a players identifier (string).

    end
end

function GetLastPosition(source)
    local identifier = GetIdentifier(source)

    if Config.Framework == 'esx' then
        local Result = DatabaseQuery('SELECT position FROM users WHERE identifier="'..identifier..'"')
        if Result and Result[1] and Result[1].position and #Result[1].position > 0 then
            return json.decode(Result[1].position)
        end

    elseif Config.Framework == 'qbcore' then
        local xPlayer = QBCore.Functions.GetPlayer(source)
        if xPlayer then
            return xPlayer.PlayerData.position
        end

    elseif Config.Framework == 'other' then
        --return a players last saved position (table).

    end
end

if Config.Framework == 'esx' then
    ESX.RegisterServerCallback('crow_spawnselect:CheckIfNew', function(source, cb)
        local identifier = GetIdentifier(source)
        local Result = DatabaseQuery('SELECT firstname, lastname FROM users WHERE identifier="'..identifier..'"')
        if Result and Result[1] and Result[1].firstname and #Result[1].firstname > 0 and Result[1].lastname and #Result[1].lastname > 0 then
            cb(false)
        else
            cb(true)
        end
    end)
end


-- ██████╗██╗  ██╗ █████╗ ████████╗     ██████╗ ██████╗ ███╗   ███╗███╗   ███╗ █████╗ ███╗   ██╗██████╗ ███████╗
--██╔════╝██║  ██║██╔══██╗╚══██╔══╝    ██╔════╝██╔═══██╗████╗ ████║████╗ ████║██╔══██╗████╗  ██║██╔══██╗██╔════╝
--██║     ███████║███████║   ██║       ██║     ██║   ██║██╔████╔██║██╔████╔██║███████║██╔██╗ ██║██║  ██║███████╗
--██║     ██╔══██║██╔══██║   ██║       ██║     ██║   ██║██║╚██╔╝██║██║╚██╔╝██║██╔══██║██║╚██╗██║██║  ██║╚════██║
--╚██████╗██║  ██║██║  ██║   ██║       ╚██████╗╚██████╔╝██║ ╚═╝ ██║██║ ╚═╝ ██║██║  ██║██║ ╚████║██████╔╝███████║
-- ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝        ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝ ╚══════╝


RegisterServerEvent('crow_spawnselect:Command')
AddEventHandler('crow_spawnselect:Command', function(action, data)
    local _source = source
    local identifier = GetIdentifier(_source)
    if action == 'show' then
        local Result = DatabaseQuery('SELECT personal_spawn FROM spawnselect WHERE identifier="'..identifier..'"')
        if Result and Result[1] and Result[1].personal_spawn then
            local data = json.decode(Result[1].personal_spawn)
            Notif(_source, 2, 'personalspawn_show', data.name, data.x, data.y, data.z, data.h)
        else
            Notif(_source, 3, 'personalspawn_none', Config.SpawnOptions.personal_command)
        end

    elseif action == 'set' then
        Notif(_source, 1, 'personalspawn_set', data.name, data.x, data.y, data.z, data.h)
        local personal_spawn = json.encode(data)
        local Result = DatabaseQuery('SELECT personal_spawn FROM spawnselect WHERE identifier="'..identifier..'"')
        if Result and Result[1] and Result[1].personal_spawn then
            DatabaseQuery('UPDATE spawnselect SET personal_spawn=@personal_spawn WHERE identifier=@identifier', {['@personal_spawn'] = personal_spawn, ['@identifier'] = identifier})
        else
            DatabaseQuery('INSERT INTO spawnselect (identifier, personal_spawn) VALUES (@identifier, @personal_spawn)', {['@personal_spawn'] = personal_spawn, ['@identifier'] = identifier})
        end

    elseif action == 'delete' then
        DatabaseQuery('DELETE FROM spawnselect WHERE identifier="'..identifier..'"')
        Notif(_source, 1, 'personalspawn_deleted')
    end
end)


--███╗   ██╗ ██████╗ ████████╗██╗███████╗██╗ ██████╗ █████╗ ████████╗██╗ ██████╗ ███╗   ██╗███████╗
--████╗  ██║██╔═══██╗╚══██╔══╝██║██╔════╝██║██╔════╝██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║██╔════╝
--██╔██╗ ██║██║   ██║   ██║   ██║█████╗  ██║██║     ███████║   ██║   ██║██║   ██║██╔██╗ ██║███████╗
--██║╚██╗██║██║   ██║   ██║   ██║██╔══╝  ██║██║     ██╔══██║   ██║   ██║██║   ██║██║╚██╗██║╚════██║
--██║ ╚████║╚██████╔╝   ██║   ██║██║     ██║╚██████╗██║  ██║   ██║   ██║╚██████╔╝██║ ╚████║███████║
--╚═╝  ╚═══╝ ╚═════╝    ╚═╝   ╚═╝╚═╝     ╚═╝ ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝


function Notification(source, notif_type, message)
    if source and notif_type and message then
        if Config.NotificationType.server == 'esx' then
            TriggerClientEvent('esx:showNotification', source, message)
        
        elseif Config.NotificationType.server == 'qbcore' then
            if notif_type == 1 then
                TriggerClientEvent('QBCore:Notify', source, message, 'success')
            elseif notif_type == 2 then
                TriggerClientEvent('QBCore:Notify', source, message, 'primary')
            elseif notif_type == 3 then
                TriggerClientEvent('QBCore:Notify', source, message, 'error')
            end
        
        elseif Config.NotificationType.server == 'mythic_old' then
            if notif_type == 1 then
                TriggerClientEvent('mythic_notify:client:SendAlert:custom', source, { type = 'success', text = message, length = 10000})
            elseif notif_type == 2 then
                TriggerClientEvent('mythic_notify:client:SendAlert:custom', source, { type = 'inform', text = message, length = 10000})
            elseif notif_type == 3 then
                TriggerClientEvent('mythic_notify:client:SendAlert:custom', source, { type = 'error', text = message, length = 10000})
            end

        elseif Config.NotificationType.server == 'mythic_new' then
            if notif_type == 1 then
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = message, style = { ['background-color'] = '#ffffff', ['color'] = '#000000' } })
            elseif notif_type == 2 then
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = message, style = { ['background-color'] = '#ffffff', ['color'] = '#000000' } })
            elseif notif_type == 3 then
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = message, style = { ['background-color'] = '#ffffff', ['color'] = '#000000' } })
            end

        elseif Config.NotificationType.server == 'chat' then
                TriggerClientEvent('chatMessage', source, message)

        elseif Config.NotificationType.server == 'other' then
            --add your own notification.

        end
    end
end

function Notif(source, notif_type, locale, ...)
    local message = string.format(L(locale), ...)
    Notification(source, notif_type, message)
end

function DatabaseQuery(query, params)
    -- Placeholder for database queries
    -- You'll need to implement this based on your database system
    return nil
end

