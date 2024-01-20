local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('kg-usbs:GiveCrateLoot', function(crate)
    if crate == nil then return end

    local src = source

    local Player = QBCore.Functions.GetPlayer(src)

    for i = 1, Config.AmountToGive do
        local item = Config.CrateItems[math.random(1, #Config.CrateItems)]
        local amount = 1

        Player.Functions.AddItem(item, amount)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "add", amount)
    end

    TriggerClientEvent('kg-usbs:RemoveCrate', src)
end)

RegisterServerEvent('kg-usbs:RedUsb:RemoveUSB', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    Player.Functions.RemoveItem('red_usb', 1)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['red_usb'], "remove", 1)
end)