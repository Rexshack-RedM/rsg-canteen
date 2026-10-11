local RSGCore = exports['rsg-core']:GetCoreObject()

-- next tier when drinking (canteen0 cannot be drunk from)
local DEGRADE = {
    canteen100 = 'canteen75',
    canteen75  = 'canteen50',
    canteen50  = 'canteen25',
    canteen25  = 'canteen0',
}

-- tiers that can be topped up to canteen100
local REFILLABLE = {
    canteen0  = true,
    canteen25 = true,
    canteen50 = true,
    canteen75 = true,
}

local PENDING_TIMEOUT = 30 -- seconds a use stays valid while the client animates
local pending = {}         -- [src] = { item = name, time = os.time() }

------------------------
-- helpers
------------------------
local function SwapItem(src, fromItem, toItem, reason)
    if not exports['rsg-inventory']:RemoveItem(src, fromItem, 1, nil, reason) then return false end
    TriggerClientEvent('rsg-inventory:client:ItemBox', src, RSGCore.Shared.Items[fromItem], 'remove', 1)
    exports['rsg-inventory']:AddItem(src, toItem, 1, nil, nil, reason)
    TriggerClientEvent('rsg-inventory:client:ItemBox', src, RSGCore.Shared.Items[toItem], 'add', 1)
    return true
end

local function AddThirst(src, Player, amount)
    local thirst = math.min(100, (Player.PlayerData.metadata.thirst or 0) + amount)
    Player.Functions.SetMetaData('thirst', thirst)
    TriggerClientEvent('hud:client:UpdateThirst', src, thirst)
end

------------------------
-- usable items
------------------------
local function OnUse(source, item)
    local src = source
    if not RSGCore.Functions.GetPlayer(src) then return end
    local p = pending[src]
    if p and os.time() - p.time < PENDING_TIMEOUT then return end -- already drinking
    pending[src] = { item = item.name, time = os.time() }
    TriggerClientEvent('rsg-canteen:client:drink', src, item.name)
end

for name in pairs(DEGRADE) do RSGCore.Functions.CreateUseableItem(name, OnUse) end
RSGCore.Functions.CreateUseableItem('canteen0', OnUse)

------------------------
-- client reports result of a use: 'refill' | 'drink' | 'cancel'
------------------------
RegisterNetEvent('rsg-canteen:server:finish', function(action)
    local src = source
    local p = pending[src]
    pending[src] = nil
    if not p or os.time() - p.time > PENDING_TIMEOUT then return end

    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then return end

    if action == 'refill' and REFILLABLE[p.item] then
        if SwapItem(src, p.item, 'canteen100', 'canteen-refill') then
            AddThirst(src, Player, Config.RefillThirst)
        end
    elseif action == 'drink' and DEGRADE[p.item] then
        if SwapItem(src, p.item, DEGRADE[p.item], 'canteen-drink') then
            AddThirst(src, Player, Config.DrinkAmount)
        end
    end
end)

AddEventHandler('playerDropped', function()
    pending[source] = nil
end)

------------------------
-- external refill (server-side only)
-- exports['rsg-canteen']:RefillCanteen(src, 'canteen25')
------------------------
exports('RefillCanteen', function(src, fromItem)
    if not REFILLABLE[fromItem] or not RSGCore.Functions.GetPlayer(src) then return false end
    return SwapItem(src, fromItem, 'canteen100', 'canteen-refill-external')
end)
