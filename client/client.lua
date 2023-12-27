local RSGCore = exports['rsg-core']:GetCoreObject()
local isBusy = false

-- drink water from flask
RegisterNetEvent('rsg-canteen:client:drink', function(amount)
    if isBusy then
        return
    else
        isBusy = not isBusy
        local ped = PlayerPedId()
        SetCurrentPedWeapon(PlayerPedId(), GetHashKey("weapon_unarmed"))
        Citizen.Wait(100)
        if not IsPedOnMount(ped) and not IsPedInAnyVehicle(ped) then
            TaskStartScenarioInPlace(ped, GetHashKey('WORLD_HUMAN_DRINK_FLASK'), -1, true, false, false, false)
        end
        Wait(5000)
        TriggerServerEvent("RSGCore:Server:SetMetaData", "thirst", RSGCore.Functions.GetPlayerData().metadata["thirst"] + amount)
        ClearPedTasks(ped)
        isBusy = not isBusy
    end
end)

-- fill up empty flask
RegisterNetEvent('rsg-canteen:client:fillupcanteen', function()
    if isBusy then
        return
    else
        isBusy = not isBusy
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local water = Citizen.InvokeNative(0x5BA7A68A346A5A91,coords.x+3, coords.y+3, coords.z)

        for k,v in pairs(Config.WaterTypes) do 
            if water == Config.WaterTypes[k]["waterhash"]  then
                if IsPedOnFoot(playerPed) then
                    if IsEntityInWater(playerPed) then
                        TriggerServerEvent('rsg-canteen:server:givefullcanteen')
                        ClearPedTasks(playerPed)
                    end
                end
            end
        end
        isBusy = not isBusy
    end
end)

-- JoewAlabel Fill Up Canteens at waterpumps too.
RegisterNetEvent('rsg-canteen:client:fillupcanteenwaterpump', function()
    if isBusy then
        return
    else
        isBusy = not isBusy
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local water = Citizen.InvokeNative(0x5BA7A68A346A5A91,coords.x+3, coords.y+3, coords.z)
                if IsPedOnFoot(playerPed) then
					TriggerServerEvent('rsg-canteen:server:givefullcanteen')        
                end
        isBusy = not isBusy
    end
end)

-- JoewAlabel Check if have canteen to fill
RegisterNetEvent('rsg-canteen:client:fillupcanteenwaterpump:havecanteen', function()
	local playerPed = PlayerPedId()
    TaskStartScenarioInPlace(playerPed, GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), -1, true, false, false, false)
    Wait(8000)
	ClearPedTasks(playerPed)
end)