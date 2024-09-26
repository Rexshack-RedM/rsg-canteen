local RSGCore = exports['rsg-core']:GetCoreObject()

-- use canteen 100
RSGCore.Functions.CreateUseableItem("canteen100", function(source, item)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    TriggerClientEvent('rsg-canteen:client:drink', src, Config.DrinkAmount)
    Player.Functions.RemoveItem('canteen100', 1)
    Player.Functions.AddItem('canteen75', 1)
end)

-- use canteen 75
RSGCore.Functions.CreateUseableItem("canteen75", function(source, item)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    TriggerClientEvent('rsg-canteen:client:drink', src, Config.DrinkAmount)
    Player.Functions.RemoveItem('canteen75', 1)
    Player.Functions.AddItem('canteen50', 1)
end)

-- use canteen 50
RSGCore.Functions.CreateUseableItem("canteen50", function(source, item)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    TriggerClientEvent('rsg-canteen:client:drink', src, Config.DrinkAmount)
    Player.Functions.RemoveItem('canteen50', 1)
    Player.Functions.AddItem('canteen25', 1)
end)

-- use canteen 25
RSGCore.Functions.CreateUseableItem("canteen25", function(source, item)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    TriggerClientEvent('rsg-canteen:client:drink', src, Config.DrinkAmount)
    Player.Functions.RemoveItem('canteen25', 1)
    Player.Functions.AddItem('canteen0', 1)
end)

-- use canteen 0 - error or fillup
RSGCore.Functions.CreateUseableItem("canteen0", function(source, item)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    TriggerClientEvent('rsg-canteen:client:fillupcanteen', src)
end)

-- remove empty give full canteen
RegisterServerEvent('rsg-canteen:server:givefullcanteen')
AddEventHandler('rsg-canteen:server:givefullcanteen', function()
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    Player.Functions.RemoveItem('canteen0', 1)
    TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items['canteen0'], "remove")
    Player.Functions.AddItem('canteen100', 1)
    TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items['canteen100'], "add")
end)
