local isBusy = false
lib.locale()

local VALID_WATER = {}
for _, v in ipairs(Config.WaterTypes) do VALID_WATER[v.waterhash] = true end

local REFILLABLE = { canteen0 = true, canteen25 = true, canteen50 = true, canteen75 = true }

local DRINK_DICT = 'amb_rest_drunk@world_human_drinking@female_a@idle_a'
local PROP_MODEL = joaat('p_cs_canteen_hercule')

local function InValidWater(ped)
    if not IsEntityInWater(ped) or not IsPedOnFoot(ped) then return false end
    local c = GetEntityCoords(ped)
    return VALID_WATER[GetWaterMapZoneAtCoords(c.x, c.y, c.z)] == true
end

local function NotifyEmpty()
    lib.notify({ title = locale('canteen_empty_title'), description = locale('canteen_empty_desc'), type = 'error', duration = 7000 })
end

------------------------
-- use canteen (triggered by server on item use)
------------------------
RegisterNetEvent('rsg-canteen:client:drink', function(item)
    local ped = cache.ped
    if isBusy or IsEntityDead(ped) then
        return TriggerServerEvent('rsg-canteen:server:finish', 'cancel')
    end

    local refill = REFILLABLE[item] and InValidWater(ped)

    -- empty canteen and no water to fill it from
    if item == 'canteen0' and not refill then
        NotifyEmpty()
        return TriggerServerEvent('rsg-canteen:server:finish', 'cancel')
    end

    isBusy = true
    SetCurrentPedWeapon(ped, joaat('weapon_unarmed'), true)

    local prop
    if not IsPedOnMount(ped) and not IsPedInAnyVehicle(ped, false) then
        lib.requestModel(PROP_MODEL)
        local coords = GetEntityCoords(ped)
        prop = CreateObject(PROP_MODEL, coords.x, coords.y, coords.z, true, false, false)
        SetModelAsNoLongerNeeded(PROP_MODEL)
        AttachEntityToEntity(prop, ped, GetEntityBoneIndexByName(ped, 'SKEL_R_HAND'),
            0.10, 0.09, -0.05, 306.0, 18.0, 0.0, true, true, false, true, 2, true)

        if refill then
            TaskStartScenarioInPlace(ped, joaat('WORLD_HUMAN_CROUCH_INSPECT'), -1, true, false, false, false)
            Wait(8000)
            ClearPedTasks(ped)
        end

        lib.requestAnimDict(DRINK_DICT)
        TaskPlayAnim(ped, DRINK_DICT, 'idle_a', 1.0, 1.0, -1, 31, 1.0, false, false, false)
        RemoveAnimDict(DRINK_DICT)
    end

    Wait(5000)

    -- re-check water at the end so walking out mid-animation doesn't count
    if refill and not InValidWater(ped) then refill = false end

    if refill then
        TriggerServerEvent('rsg-canteen:server:finish', 'refill')
    elseif item ~= 'canteen0' then
        TriggerServerEvent('rsg-canteen:server:finish', 'drink')
    else
        NotifyEmpty()
        TriggerServerEvent('rsg-canteen:server:finish', 'cancel')
    end

    ClearPedTasks(ped)
    if prop and DoesEntityExist(prop) then DeleteObject(prop) end
    isBusy = false
end)
