local QBCore = exports['qb-core']:GetCoreObject()

-- TESTING --

QBCore.Commands.Add('sj', Lang:t('commands.softcuff'), {}, false, function(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    TriggerClientEvent('stj:client:JacketPlayerSoft', src)
end)


-- TESTING --

RegisterNetEvent('stj:server:setJacketStatus', function(isJacketed)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        Player.Functions.SetMetaData('isjacketed', isJacketed)
    end
end)

RegisterNetEvent('stj:server:RemoveJacket', function(source)
    exports['qb-inventory']:RemoveItem(src, 'straightjacket', 1, false, 'noted-sjacket:server:main:CreateUseableItem')
end)

QBCore.Functions.CreateUseableItem('straightjacket', function(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if isJacketed == true or not Player.Functions.GetItemByName('straightjacket') then return end
    TriggerClientEvent('stj:client:JacketPlayerSoft', src)

    -- qbinventory needs to be changed
end)

QBCore.Functions.CreateUseableItem('orderlykey', function(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if isJacketed == false or not Player.Functions.GetItemByName('straightjacket') then return end
    TriggerClientEvent('stj:client:unJacketPlayer', src)

    -- qbinventory needs to be changed, insert add straightjacket here
end)

RegisterNetEvent('stj:server:unJacketPlayer', function(playerId, isSoftcuff)
    local src = source
    local playerPed = GetPlayerPed(src)
    local targetPed = GetPlayerPed(playerId)
    local playerCoords = GetEntityCoords(playerPed)
    local targetCoords = GetEntityCoords(targetPed)
    if #(playerCoords - targetCoords) > 2.5 then return DropPlayer(src, 'Attempted exploit abuse') end

    local Player = QBCore.Functions.GetPlayer(src)
    local CuffedPlayer = QBCore.Functions.GetPlayer(playerId)
    if not Player or not CuffedPlayer or (not Player.Functions.GetItemByName('orderlyKey')) then return end

    TriggerClientEvent('stj:client:unJacketPlayerAction', CuffedPlayer.PlayerData.source, Player.PlayerData.source, isSoftcuff)
end)

RegisterNetEvent('stj:server:JacketPlayer', function(playerId, isSoftjacket)
    local src = source
    local playerPed = GetPlayerPed(src)
    local targetPed = GetPlayerPed(playerId)
    local playerCoords = GetEntityCoords(playerPed)
    local targetCoords = GetEntityCoords(targetPed)
    if #(playerCoords - targetCoords) > 2.5 then return DropPlayer(src, 'Attempted exploit abuse') end

    local Player = QBCore.Functions.GetPlayer(src)
    local CuffedPlayer = QBCore.Functions.GetPlayer(playerId)
    if not Player or not CuffedPlayer or (not Player.Functions.GetItemByName('straightjacket') and Player.PlayerData.job.type ~= 'leo') then return end

    TriggerClientEvent('stj:client:GetJacketed', CuffedPlayer.PlayerData.source, Player.PlayerData.source, isSoftjacket)
end)