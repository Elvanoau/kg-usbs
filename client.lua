local QBCore = exports['qb-core']:GetCoreObject()
local Blip = nil
local CurrentCops = 0
local redusbcrate = nil

redguards = {
    ['guards'] = {}
}

local function loadModel(model)
    if type(model) == 'number' then
        model = model
    else
        model = GetHashKey(model)
    end
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(0)
    end
end

local function SpawnGuards()
    local ped = PlayerPedId()

    SetPedRelationshipGroupHash(ped, `PLAYER`)
    AddRelationshipGroup('guards')

    for k, v in pairs(Config['redguards']['guards']) do
        loadModel(v['model'])
        redguards['guards'][k] = CreatePed(26, GetHashKey(v['model']), v['coords'], v['heading'], true, true)
        NetworkRegisterEntityAsNetworked(redguards['guards'][k])
        networkID = NetworkGetNetworkIdFromEntity(redguards['guards'][k])
        SetNetworkIdCanMigrate(networkID, true)
        SetNetworkIdExistsOnAllMachines(networkID, true)
        SetPedRandomComponentVariation(redguards['guards'][k], 0)
        SetPedRandomProps(redguards['guards'][k])
        SetEntityAsMissionEntity(redguards['guards'][k])
        SetEntityVisible(redguards['guards'][k], true)
        SetPedRelationshipGroupHash(redguards['guards'][k], `guards`)
        SetPedAccuracy(redguards['guards'][k], 75)
        SetPedArmour(redguards['guards'][k], 100)
        SetPedCanSwitchWeapon(redguards['guards'][k], true)
        SetPedDropsWeaponsWhenDead(redguards['guards'][k], false)
        SetPedFleeAttributes(redguards['guards'][k], 0, false)
        GiveWeaponToPed(redguards['guards'][k], `WEAPON_PISTOL`, 255, false, false)
        local random = math.random(1, 2)
        if random == 2 then
            TaskGuardCurrentPosition(redguards['guards'][k], 10.0, 10.0, 1)
        end
    end

    SetRelationshipBetweenGroups(0, `guards`, `guards`)
    SetRelationshipBetweenGroups(5, `guards`, `PLAYER`)
    SetRelationshipBetweenGroups(5, `PLAYER`, `guards`)
end

local function SendLocation()
    local BlipV3 = Config.RedCoords[math.random(1, #Config.RedCoords)]
    SearchCoords = BlipV3
    Blip = AddBlipForCoord(BlipV3.x, BlipV3.y, BlipV3.z)
    SetBlipSprite (Blip, 615)
    SetBlipDisplay(Blip, 6)
    SetBlipScale  (Blip, 0.7)
    SetBlipAsShortRange(Blip, false)
    SetBlipColour(Blip, 48)
    SetBlipRoute(Blip, true)
    SetBlipRouteColour(Blip, 48)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Loot Location")
    EndTextCommandSetBlipName(Blip)

    QBCore.Functions.Notify('Check Your Map!', 'success')

    local model = `sm_prop_smug_crate_l_fake`
    RequestModel(model)
    while not HasModelLoaded(model) do
      Wait(1)
    end

    redusbcrate = CreateObject(model, BlipV3.x, BlipV3.y, BlipV3.z, true, true, false)

    PlaceObjectOnGroundProperly(redusbcrate)

    SpawnGuards()

    TriggerServerEvent('kg-usbs:RedUsb:RemoveUSB')

    exports['qb-target']:AddTargetEntity(redusbcrate, {
    options = {
      {
        type = "client",
        event = "kg-usbs:StartCrate",
        label = 'Grab Loot',
      }
    },
    distance = 2.5,
  })
  
end

RegisterNetEvent('police:SetCopCount', function(amount)
    CurrentCops = amount
end)

RegisterNetEvent("kg-usbs:RedUSBDecode", function()

    if Config.Debug then

    elseif CurrentCops < Config.CopsReq then
        QBCore.Functions.Notify('Not Enough Police!', 'error')
        return
    end

    local circles = math.random(3, 7)

    exports['ps-ui']:Circle(function(success)
        if success then
            SendLocation()
        else
            QBCore.Functions.Notify('You failed to hack!', 'error')
        end
    end, circles, 10)

end)

RegisterNetEvent('kg-usbs:RemoveCrate', function()
    RemoveBlip(Blip)
    DeleteEntity(redusbcrate)
    exports['qb-target']:RemoveTargetEntity(redusbcrate)
    redusbcrate = nil
end)

RegisterNetEvent('kg-usbs:StartCrate', function()
    local time = Config.SearchTime
    if Config.Debug == true then
        time = 5000
    end

    TriggerEvent('animations:client:EmoteCommandStart', {"mechanic"})
    QBCore.Functions.Progressbar("search_register", "Grabbing Loot...", time, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        local ped = PlayerPedId()
        local loc = GetEntityCoords(ped)
        TriggerServerEvent("kg-usbs:GiveCrateLoot", redusbcrate)
        ClearPedTasks(ped)
        Wait(500)
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
    end, function() -- Cancel
        ClearPedTasks(PlayerPedId())
        QBCore.Functions.Notify("Cancelled", "error", 3500)
        ClearPedTasks(ped)
        Wait(500)
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
    end)
end)

Citizen.CreateThread(function()
    exports['qb-target']:AddBoxZone("red_usb_zone", vector3(2328.66, 2570.53, 46.68), 1, 1, {
        name = "red_usb_zone",
        heading = 60.0,
        debugPoly = false,
        minZ = 43.68,
        maxZ = 47.68,
    }, {
        options = {
            {
                type = "client",
                event = "kg-usbs:RedUSBDecode",
                label = "Decode Red USB",
            },
        },
        distance = 2.5
    })
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
  
    exports['qb-target']:RemoveZone("red_usb_zone")
    exports['qb-target']:RemoveTargetEntity(redusbcrate)
    RemoveBlip(Blip)
    DeleteEntity(redusbcrate)
end)