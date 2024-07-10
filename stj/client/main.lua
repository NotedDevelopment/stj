local isEscorting = false
isJacketed = false
QBCore = exports['qb-core']:GetCoreObject()
jacketType = 1
isEscorted = false

-- qbcore-framework/qb-policejob/blob/main/client/interactions.lua
-- RegisterNetEvent('police:client:PutInVehicle', function()
-- if isHandcuffed or isEscorted then
-- ADD IsJacketed


-- DO NOT EXPORT

local function loadAnimDict(dict) -- interactions, job,
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(10)
    end
end

local function IsTargetDead(playerId)
    local retval = false
    local hasReturned = false
    QBCore.Functions.TriggerCallback('stj:server:isPlayerDead', function(result)
        retval = result
        hasReturned = true
    end, playerId)
    while not hasReturned do
        Wait(10)
    end
    return retval
end
-- DO NOT EXPORT

local function JacketAnimation()
    local ped = PlayerPedId()
    if isJacketed == true then
        TriggerServerEvent('InteractSound_SV:PlayOnSource', 'Cuff', 0.2)
    else
        TriggerServerEvent('InteractSound_SV:PlayOnSource', 'Uncuff', 0.2)
    end

    loadAnimDict('mp_arrest_paired')
    Wait(100)
    TaskPlayAnim(ped, 'mp_arrest_paired', 'cop_p2_back_right', 3.0, 3.0, -1, 48, 0, 0, 0, 0)
    TriggerServerEvent('InteractSound_SV:PlayOnSource', 'Cuff', 0.2)
    Wait(3500)
    TaskPlayAnim(ped, 'mp_arrest_paired', 'exit', 3.0, 3.0, -1, 48, 0, 0, 0, 0)
end

local function GetJacketedAnimation(playerId)
    local ped = PlayerPedId()
    local cuffer = GetPlayerPed(GetPlayerFromServerId(playerId))
    local heading = GetEntityHeading(cuffer)
    -- change audio
    TriggerServerEvent('InteractSound_SV:PlayOnSource', 'Cuff', 0.2)
    loadAnimDict('mp_arrest_paired')
    SetEntityCoords(ped, GetOffsetFromEntityInWorldCoords(cuffer, 0.0, 0.45, 0.0))

    Wait(100)
    SetEntityHeading(ped, heading)
    TaskPlayAnim(ped, 'mp_arrest_paired', 'crook_p2_back_right', 3.0, 3.0, -1, 32, 0, 0, 0, 0, true, true, true)
    Wait(2500)
end

-- redetermine issoftcuff
RegisterNetEvent('stj:client:GetJacketed', function(playerId, isSoftcuff)
    local ped = PlayerPedId()
    if not isJacketed then
        isJacketed = true
        TriggerServerEvent('stj:server:setJacketStatus', true)
        ClearPedTasksImmediately(ped)
        if GetSelectedPedWeapon(ped) ~= `WEAPON_UNARMED` then
            SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
        end
        if not isSoftcuff then
            jacketType = 16
            GetJacketedAnimation(playerId)
        else
            jacketType = 49
            GetJacketedAnimation(playerId)
        end
        local jacketClothingData
    else
        print("jacketed twice\n")
        --[[isHandcuffed = false
        isEscorted = false
        TriggerEvent('hospital:client:isEscorted', isEscorted)
        DetachEntity(ped, true, false)
        TriggerServerEvent('police:server:SetHandcuffStatus', false)
        ClearPedTasksImmediately(ped)
        TriggerServerEvent('InteractSound_SV:PlayOnSource', 'Uncuff', 0.2)
        QBCore.Functions.Notify(Lang:t('success.uncuffed'), 'success')]]
    end
end)

RegisterNetEvent('stj:client:unJacketPlayer', function()
    if not IsPedRagdoll(PlayerPedId()) then
        local player, distance = QBCore.Functions.GetClosestPlayer()
        if player ~= -1 and distance < 1.5 then
            -- local result = QBCore.Functions.HasItem(Config.OrderlyKeyItem)

            local playerId = GetPlayerServerId(player)
            if not IsPedInAnyVehicle(GetPlayerPed(player)) and not IsPedInAnyVehicle(PlayerPedId()) then
                TriggerServerEvent('stj:server:unJacketPlayer', playerId, false)
                JacketAnimation()
            end
            --[[if result then
                local playerId = GetPlayerServerId(player)
                if not IsPedInAnyVehicle(GetPlayerPed(player)) and not IsPedInAnyVehicle(PlayerPedId()) then
                    TriggerServerEvent('stj:server:unJacketPlayer', playerId, false)
                    JacketAnimation()
                else
                    QBCore.Functions.Notify(Lang:t('error.vehicle_cuff'), 'error')
                end
            else
                QBCore.Functions.Notify(Lang:t('error.no_cuff'), 'error')
            end]]
        else
            QBCore.Functions.Notify(Lang:t('error.none_nearby'), 'error')
        end
    else
        Wait(2000)
    end
end)

RegisterNetEvent('stj:client:unJacketPlayerAction', function(playerId)
    local ped = PlayerPedId()
    isJacketed = false
    isEscorted = false
    TriggerEvent('hospital:client:isEscorted', isEscorted)
    DetachEntity(ped, true, false)
    TriggerServerEvent('stj:server:SetJacketStatus', false)
    ClearPedTasksImmediately(ped)
    TriggerServerEvent('InteractSound_SV:PlayOnSource', 'Uncuff', 0.2)
    QBCore.Functions.Notify(Lang:t('success.uncuffed'), 'success')
end)




-- needs editing
RegisterNetEvent('stj:client:JacketPlayerSoft', function()
    if not IsPedRagdoll(PlayerPedId()) then
        local player, distance = QBCore.Functions.GetClosestPlayer()
        if player ~= -1 and distance < 1.5 then
            local playerId = GetPlayerServerId(player)
            if not IsPedInAnyVehicle(GetPlayerPed(player)) and not IsPedInAnyVehicle(PlayerPedId()) then
                TriggerServerEvent('stj:server:JacketPlayer', playerId, true)
                JacketAnimation()
 --               TriggerServerEvent('stj:server:RemoveJacket', )
            else
                QBCore.Functions.Notify(Lang:t('error.vehicle_cuff'), 'error')
            end
        else
            QBCore.Functions.Notify(Lang:t('error.none_nearby'), 'error')
        end
    else
        Wait(2000)
    end
end)




--[[
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    local player = QBCore.Functions.GetPlayerData()
    isJacketed = false
    TriggerServerEvent('stj:server:SetHandcuffStatus', false)

    if player.metadata.straightjacket then
        local jacketClothingData = {
            outfitData = {
                ['accessory'] = {
                    item = 13,
                    texture = 0
                }
            }
        }
        TriggerEvent('qb-clothing:client:loadOutfit', jacketClothingData)
    else
        local jacketClothingData = {
            outfitData = {
                ['accessory'] = {
                    item = -1,
                    texture = 0
                }
            }
        }
        TriggerEvent('qb-clothing:client:loadOutfit', trackerClothingData)
    end
end)
]]

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    TriggerServerEvent('stj:server:SetJacketStatus', false)
    isJacketed = false
    isEscorted = false
    ClearPedTasks(PlayerPedId())
    DetachEntity(PlayerPedId(), true, false)
end)

-- DO NOT EXPORT -- 

exports('IsJacketed', function()
    return isJacketed
end)


CreateThread(function()
    while true do
        Wait(1)
        if isEscorted then
            DisableAllControlActions(0)
            EnableControlAction(0, 1, true)
            EnableControlAction(0, 2, true)
            EnableControlAction(0, 245, true)
            EnableControlAction(0, 38, true)
            EnableControlAction(0, 322, true)
            EnableControlAction(0, 249, true)
            EnableControlAction(0, 46, true)
        end

        if isJacketed then
            DisableControlAction(0, 24, true)  -- Attack
            DisableControlAction(0, 257, true) -- Attack 2
            DisableControlAction(0, 25, true)  -- Aim
            DisableControlAction(0, 263, true) -- Melee Attack 1

            DisableControlAction(0, 45, true)  -- Reload
            DisableControlAction(0, 22, true)  -- Jump
            DisableControlAction(0, 44, true)  -- Cover
            DisableControlAction(0, 37, true)  -- Select Weapon
            DisableControlAction(0, 23, true)  -- Also 'enter'?

            DisableControlAction(0, 288, true) -- Disable phone
            DisableControlAction(0, 289, true) -- Inventory
            DisableControlAction(0, 170, true) -- Animations
            DisableControlAction(0, 167, true) -- Job

            DisableControlAction(0, 26, true)  -- Disable looking behind
            DisableControlAction(0, 73, true)  -- Disable clearing animation
            DisableControlAction(2, 199, true) -- Disable pause screen

            DisableControlAction(0, 59, true)  -- Disable steering in vehicle
            DisableControlAction(0, 71, true)  -- Disable driving forward in vehicle
            DisableControlAction(0, 72, true)  -- Disable reversing in vehicle

            DisableControlAction(2, 36, true)  -- Disable going stealth

            DisableControlAction(0, 264, true) -- Disable melee
            DisableControlAction(0, 257, true) -- Disable melee
            DisableControlAction(0, 140, true) -- Disable melee
            DisableControlAction(0, 141, true) -- Disable melee
            DisableControlAction(0, 142, true) -- Disable melee
            DisableControlAction(0, 143, true) -- Disable melee
            DisableControlAction(0, 75, true)  -- Disable exit vehicle
            DisableControlAction(27, 75, true) -- Disable exit vehicle
            EnableControlAction(0, 249, true)  -- Added for talking while cuffed
            EnableControlAction(0, 46, true)   -- Added for talking while cuffed

            if (not IsEntityPlayingAnim(PlayerPedId(), 'mp_arresting', 'idle', 3) and not IsEntityPlayingAnim(PlayerPedId(), 'mp_arrest_paired', 'crook_p2_back_right', 3)) and not QBCore.Functions.GetPlayerData().metadata['isdead'] then
                loadAnimDict('mp_arresting')
                TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'idle', 8.0, -8, -1, jacketType, 0, 0, 0, 0)
            end
        end
        if not isJacketed and not isEscorted then
            Wait(2000)
        end
    end
end)

-- DO NOT EXPORT -- 