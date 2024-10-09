local RSGCore = exports['rsg-core']:GetCoreObject()
local isBusy = false
local entity = nil

-- set animation
local function getAnimationForGender(playerPed)
    local isMale = IsPedMale(playerPed)
    if isMale then
        return 'WORLD_HUMAN_DRINK_FLASK'
    else
        return {
            dict = 'amb_rest_drunk@world_human_drinking@female_a@idle_a',
            anim = 'idle_a'
        }
    end
end

-- function to load the model
local function LoadModel(modelHash)
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Citizen.Wait(100)
    end
end

-- drink water from flask
RegisterNetEvent('rsg-canteen:client:drink', function(amount)
    if isBusy then
        return
    else
        isBusy = not isBusy
        SetCurrentPedWeapon(PlayerPedId(), joaat('weapon_unarmed'))
        Citizen.Wait(100)
        if not IsPedOnMount(cache.ped) and not IsPedInAnyVehicle(cache.ped) then
            
            local dict = 'amb_rest_drunk@world_human_drinking@female_a@idle_a'
            local anim = 'idle_a'
            local ped = cache.ped
            local coords = GetEntityCoords(ped)
            local boneIndex = GetEntityBoneIndexByName(ped, "SKEL_R_HAND")
            local modelHash = GetHashKey("p_cs_canteen_hercule")
            LoadModel(modelHash)
            entity = CreateObject(modelHash, coords.x + 0.3, coords.y, coords.z, true, false, false)
            SetEntityVisible(entity, true)
            SetEntityAlpha(entity, 255, false)
            Citizen.InvokeNative(0x283978A15512B2FE, entity, true)
            SetModelAsNoLongerNeeded(modelHash)
            AttachEntityToEntity(entity, ped, boneIndex, 0.10, 0.09, -0.05, 306.0, 18.0, 0.0, true, true, false, true, 2, true)

            RequestAnimDict(dict)
            while not HasAnimDictLoaded(dict) do
                Citizen.Wait(100)
            end
            TaskPlayAnim(ped, dict, anim, 1.0, 1.0, -1, 31, 1.0, false, false, false)
        end
        Wait(5000)
        TriggerServerEvent("RSGCore:Server:SetMetaData", "thirst", RSGCore.Functions.GetPlayerData().metadata["thirst"] + amount)
        ClearPedTasks(cache.ped)
        if entity then
            DeleteObject(entity)
            entity = nil
        end
        isBusy = not isBusy
    end
end)

-- fill up empty flask
RegisterNetEvent('rsg-canteen:client:fillupcanteen', function()
    if isBusy then
        return
    else
        isBusy = not isBusy
        local coords = GetEntityCoords(cache.ped)
        local water = GetWaterMapZoneAtCoords(coords.x + 3, coords.y + 3, coords.z)

        for k, v in pairs(Config.WaterTypes) do
            if water == Config.WaterTypes[k]["waterhash"] then
                if IsPedOnFoot(cache.ped) then
                    if IsEntityInWater(cache.ped) then
                        TaskStartScenarioInPlace(cache.ped, joaat('WORLD_HUMAN_CROUCH_INSPECT'), -1, true, false, false, false)
                        Wait(8000)
                        TriggerServerEvent('rsg-canteen:server:givefullcanteen')
                        ClearPedTasks(cache.ped)
                    end
                end
            end
        end
        isBusy = not isBusy
    end
end)
