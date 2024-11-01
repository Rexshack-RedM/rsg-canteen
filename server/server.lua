local RSGCore = exports['rsg-core']:GetCoreObject()

------------------------
-- use canteen 100
------------------------
RSGCore.Functions.CreateUseableItem('canteen100', function(source, item)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then return end
    TriggerClientEvent('rsg-canteen:client:drink', src, Config.DrinkAmount, 'canteen100')
    Player.Functions.RemoveItem('canteen100', 1)
    Player.Functions.AddItem('canteen75', 1)
end)

------------------------
-- use canteen 75
------------------------
RSGCore.Functions.CreateUseableItem('canteen75', function(source, item)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then return end
    TriggerClientEvent('rsg-canteen:client:drink', src, Config.DrinkAmount, 'canteen75')
    Player.Functions.RemoveItem('canteen75', 1)
    Player.Functions.AddItem('canteen50', 1)
end)

------------------------
-- use canteen 50
------------------------
RSGCore.Functions.CreateUseableItem('canteen50', function(source, item)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then return end
    TriggerClientEvent('rsg-canteen:client:drink', src, Config.DrinkAmount, 'canteen50')
    Player.Functions.RemoveItem('canteen50', 1)
    Player.Functions.AddItem('canteen25', 1)
end)

------------------------
-- use canteen 25
------------------------
RSGCore.Functions.CreateUseableItem('canteen25', function(source, item)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then return end
    TriggerClientEvent('rsg-canteen:client:drink', src, Config.DrinkAmount, 'canteen25')
    Player.Functions.RemoveItem('canteen25', 1)
    TriggerClientEvent('rsg-inventory:client:ItemBox', src, RSGCore.Shared.Items['canteen25'], 'remove', 1)
    Player.Functions.AddItem('canteen0', 1)
    TriggerClientEvent('rsg-inventory:client:ItemBox', src, RSGCore.Shared.Items['canteen0'], 'add', 1)
end)

------------------------
-- use canteen 0
------------------------
RSGCore.Functions.CreateUseableItem('canteen0', function(source, item)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then return end
    TriggerClientEvent('rsg-canteen:client:drink', src, Config.DrinkAmount, 'canteen0')
end)

------------------------
-- give full canteen
------------------------
RegisterServerEvent('rsg-canteen:server:givefullcanteen')
AddEventHandler('rsg-canteen:server:givefullcanteen', function()
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then return end
    Player.Functions.RemoveItem('canteen0', 1)
    TriggerClientEvent('rsg-inventory:client:ItemBox', src, RSGCore.Shared.Items['canteen0'], 'remove', 1)
    Player.Functions.AddItem('canteen100', 1)
    TriggerClientEvent('rsg-inventory:client:ItemBox', src, RSGCore.Shared.Items['canteen100'], 'add', 1)
end)
