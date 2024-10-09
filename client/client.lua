local RSGCore = exports['rsg-core']:GetCoreObject()
local isBusy = false
local entity = nil

------------------------
-- function load model
------------------------
local function LoadModel(modelHash)
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Wait(100)
    end
end

------------------------
-- drink water from flask
------------------------
RegisterNetEvent('rsg-canteen:client:drink', function(amount, item)
    if isBusy then return end
    if item == 'canteen0' then
        lib.notify({ title = 'Canteen Empty', description = 'you need to fill up your canteen first!', type = 'error', duration = 7000 })
        return
    end
    isBusy = true
    SetCurrentPedWeapon(cache.ped, joaat('weapon_unarmed'))
    Wait(100)
    if not IsPedOnMount(cache.ped) and not IsPedInAnyVehicle(cache.ped) then
        local dict = 'amb_rest_drunk@world_human_drinking@female_a@idle_a'
        local anim = 'idle_a'
        local coords = GetEntityCoords(cache.ped)
        local boneIndex = GetEntityBoneIndexByName(cache.ped, 'SKEL_R_HAND')
        local modelHash = GetHashKey('p_cs_canteen_hercule')
        LoadModel(modelHash)
        entity = CreateObject(modelHash, coords.x + 0.3, coords.y, coords.z, true, false, false)
        SetEntityVisible(entity, true)
        SetEntityAlpha(entity, 255, false)
        Citizen.InvokeNative(0x283978A15512B2FE, entity, true)
        SetModelAsNoLongerNeeded(modelHash)
        AttachEntityToEntity(entity, cache.ped, boneIndex, 0.10, 0.09, -0.05, 306.0, 18.0, 0.0, true, true, false, true, 2, true)

        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Citizen.Wait(100)
        end
        TaskPlayAnim(cache.ped, dict, anim, 1.0, 1.0, -1, 31, 1.0, false, false, false)
    end
    Wait(5000)
    TriggerServerEvent("RSGCore:Server:SetMetaData", "thirst", RSGCore.Functions.GetPlayerData().metadata["thirst"] + amount)
    ClearPedTasks(cache.ped)
    if entity then
        DeleteObject(entity)
        entity = nil
    end
    isBusy = false
end)
