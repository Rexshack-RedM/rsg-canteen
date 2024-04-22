local RSGCore = exports['rsg-core']:GetCoreObject()
local isBusy = false

-- drink water from flask
RegisterNetEvent('rsg-canteen:client:drink', function(amount)
    if isBusy then
        return
    else
        isBusy = not isBusy
        SetCurrentPedWeapon(PlayerPedId(), joaat('weapon_unarmed'))
        Citizen.Wait(100)
        if not IsPedOnMount(cache.ped) and not IsPedInAnyVehicle(cache.ped) then
            TaskStartScenarioInPlace(cache.ped, joaat('WORLD_HUMAN_DRINK_FLASK'), -1, true, false, false, false)
        end
        Wait(5000)
        TriggerServerEvent("RSGCore:Server:SetMetaData", "thirst", RSGCore.Functions.GetPlayerData().metadata["thirst"] + amount)
        ClearPedTasks(cache.ped)
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
        local water = GetWaterMapZoneAtCoords(coords.x+3, coords.y+3, coords.z)

        for k,v in pairs(Config.WaterTypes) do 
            if water == Config.WaterTypes[k]["waterhash"]  then
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
