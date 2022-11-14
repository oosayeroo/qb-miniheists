local QBCore = exports['qb-core']:GetCoreObject()
local GotJob = false
local Finished = true
local GotJobA = false
local GotJobB = false
local GotJobC = false
local carmodel = nil
local location = nil
--local labtargetblip = nil
local labcoords1 = vector3(3536.97, 3669.4, 28.12)
local labcoords2 = vector3(3559.71, 3673.84, 28.12)
local mwcoords = vector3(572.9, -3123.86, 18.74)
local CurrentCops = 0
local SecurityBypass = false
local HackingTime = Config.HackingTime*1000
local EmailTime = Config.EmailTime*1000

RegisterNetEvent('police:SetCopCount', function(amount)
    CurrentCops = amount
end)

Citizen.CreateThread(function()
    exports['qb-target']:SpawnPed({
        model = Config.CarBossModel,
        coords = Config.CarBossLocation, 
        minusOne = true, --may have to change this if your ped is in the ground
        freeze = true, 
        invincible = true, 
        blockevents = true,
        scenario = Config.CarBossScenario,
        target = { 
            options = {
                {
                    type = "client",
                    event = "qb-miniheists:getJobA",
                    icon = "fas fa-car",
                    label = "Start Low-Range Job",
                },
                {
                    type = "client",
                    event = "qb-miniheists:getJobB",
                    icon = "fas fa-car",
                    label = "Start Mid-Range Job",
                },
                {
                    type = "client",
                    event = "qb-miniheists:getJobC",
                    icon = "fas fa-car",
                    label = "Start High-Range Job",
                },
            },
          distance = 2.5,
        },
    })
end)

Citizen.CreateThread(function()
    exports['qb-target']:SpawnPed({
        model = Config.LabBossModel,
        coords = Config.LabBossLocation, 
        minusOne = true, --may have to change this if your ped is in the ground
        freeze = true, 
        invincible = true, 
        blockevents = true,
        scenario = Config.LabBossScenario,
        target = { 
            options = {
                {
                    type = "client",
                    event = "qb-miniheists:LabRaid",
                    icon = "fas fa-comment",
                    label = "Start Lab Raid",
                },
                {
                    type = "server",
                    event = "qb-miniheists:RecievePaymentLab",
                    icon = "fas fa-hand",
                    label = "HandOver Research",
                    item = { 
                        "lab-usb",
                        "lab-samples",
                        "lab-files",
                    },
                },
            },
          distance = 2.5,
        },
    })
end)

Citizen.CreateThread(function()
    exports['qb-target']:SpawnPed({
        model = Config.MWBossModel,
        coords = Config.MWBossLocation, 
        minusOne = true, --may have to change this if your ped is in the ground
        freeze = true, 
        invincible = true, 
        blockevents = true,
        scenario = Config.MWBossScenario,
        target = { 
            options = {
                {
                    type = "client",
                    event = "qb-miniheists:StartMWRaid",
                    icon = "fas fa-comment",
                    label = "Start MerryWeather Raid",
                },
                {
                    type = "server",
                    event = "qb-miniheists:ReceivePaymentMW",
                    icon = "fas fa-hand",
                    label = "Receive Payment",
                    item = "mw-usb",
                },
            },
          distance = 2.5,
        },
    })
end)

--Lab Raid Stuff --------------------------------------------------------------------------------------------------

RegisterNetEvent('qb-miniheists:LabRaid', function()
    if GotJob == false then
        TriggerEvent('animations:client:EmoteCommandStart', {"wait"})
            QBCore.Functions.Progressbar('pickup', 'Getting Job...', 5000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function()
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                QBCore.Functions.Notify('You will be emailed shortly with the location', 'primary')
                if CurrentCops >= Config.MinimumPolice then
                    Wait(EmailTime)
                    TriggerServerEvent('qb-phone:server:sendNewMail', {
                    sender = 'Lugo Bervich',
                    subject = 'Bio Research...',
                    message = 'Heres the location. You Need to hack the firewall through the computer in laboratory 1 and then download that research. <br/> i will email again when i see the firewall is down!',
                    })
                    SetNewWaypoint(labcoords1)
                    ExportLabTarget1()
                    ExportSecurityTarget()
                else
                    QBCore.Functions.Notify('Not enough police presence', 'error', 3000)
                end
            end)
        else
        QBCore.Functions.Notify('You Already Have a Job', 'error', 3000)
    end
end)

RegisterNetEvent('qb-miniheists:StartLabHack', function()
    if QBCore.Functions.HasItem(Config.HackItem) then
        TriggerServerEvent('police:server:policeAlert', 'Break in at Humane Labs, Laboratory 1!')
        TriggerEvent('animations:client:EmoteCommandStart', {"type"})
        QBCore.Functions.Progressbar('cnct_elect', 'Bypassing Firewall...', HackingTime, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function()
        end)
        Wait(HackingTime)
        TriggerEvent('animations:client:EmoteCommandStart', {"type"})
        exports['ps-ui']:Scrambler(function(success)
            if success then
                Wait(100)
                TriggerEvent('animations:client:EmoteCommandStart', {"type"})
                Wait(500)
                QBCore.Functions.Progressbar('po_usb', 'Downloading Research..', HackingTime, false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {}, {}, {}, function()
                end)
                Wait(HackingTime)
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                TriggerServerEvent('qb-miniheists:LabHackDone')
                if SecurityBypass == false then
                    SpawnGuardsLab()
                end
                QBCore.Functions.Notify('You Successfully Downloaded the Research, Wait for New Email!', 'primary', 8000)
                Wait(7500)
                TriggerServerEvent('qb-phone:server:sendNewMail', {
                    sender = 'Lugo Bervich',
                    subject = 'Bio-Research...',
                    message = 'Great you did it! now head to the Cold Room and bring me some samples of their work and any files you see!',
                    })
                RemoveLabTarget1()
                ExportLabTarget2()
            else
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                QBCore.Functions.Notify('You failed Hacking, try again', 'error', 5000)
                    if SecurityBypass == false then
                        SpawnGuardsLab()
                        QBCore.Functions.Notify('Guards Alerted!', 'error', 2000)
                    end
                end
            end, Config.LabHackType, Config.LabHackTime, 0)
        else
            QBCore.Functions.Notify('You dont have the hack device', 'error', 3000)
        end
end)

RegisterNetEvent('qb-miniheists:StartLabHack2', function()
    TriggerEvent('animations:client:EmoteCommandStart', {"mechanic"})
    QBCore.Functions.Progressbar('cnct_elect', 'Grabbing Samples and Files...', HackingTime, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
    end)
    Wait(HackingTime)
    TriggerEvent('animations:client:EmoteCommandStart', {"c"})
    TriggerServerEvent('qb-miniheists:GrabSamples')
    if SecurityBypass == false then
        SpawnGuardsLab()
    end
    QBCore.Functions.Notify('You got everything, Get out of there!', 'primary', 8000)
    Wait(7500)
    TriggerServerEvent('qb-phone:server:sendNewMail', {
        sender = 'Lugo Bervich',
        subject = 'Bio-Research...',
        message = 'Now Bring the Research, Samples and Files back to me for your payment!',
        })
    GotJob = false
    Finished = true
    SecurityBypass = false
    RemoveLabTarget2()
end)
  
RegisterNetEvent('qb-miniheists:BypassLabGuardAlarm', function()
    if QBCore.Functions.HasItem(Config.HackItem) then
        TriggerEvent('animations:client:EmoteCommandStart', {"type"})
        QBCore.Functions.Progressbar('cnct_elect', 'Bypassing Security Alarms...', HackingTime, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function()
        end)
        Wait(HackingTime)
        TriggerEvent('animations:client:EmoteCommandStart', {"type"})
        exports['ps-ui']:Scrambler(function(success)
            if success then
                Wait(100)
                TriggerEvent('animations:client:EmoteCommandStart', {"type"})
                Wait(500)
                QBCore.Functions.Progressbar('po_usb', 'Rerouting Alarm Checks..', HackingTime, false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {}, {}, {}, function()
                end)
                Wait(HackingTime)
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                QBCore.Functions.Notify('You Successfully Disabled the alarm system, head on in', 'primary', 8000)
                SecurityBypass = true
                RemoveLabBypass()
            else
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                QBCore.Functions.Notify('You failed to bypass security alarms, careful in there', 'error', 5000)
                RemoveLabBypass()
                end
            end, Config.LabHackType, Config.BypassHackTime, 0)
        else
            QBCore.Functions.Notify('You dont have the hack device', 'error', 3000)
        end
end)

labsecurity = {
    ['labpatrol'] = {}
}

function loadModel(model)
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

function SpawnGuardsLab()
    local ped = PlayerPedId()
    local randomgun = Config.LabGuardWeapon[math.random(1, #Config.LabGuardWeapon)]

    SetPedRelationshipGroupHash(ped, `PLAYER`)
    AddRelationshipGroup('labpatrol')

    for k, v in pairs(Config['labsecurity']['labpatrol']) do
        loadModel(v['model'])
        labsecurity['labpatrol'][k] = CreatePed(26, GetHashKey(v['model']), v['coords'], v['heading'], true, true)
        NetworkRegisterEntityAsNetworked(labsecurity['labpatrol'][k])
        networkID = NetworkGetNetworkIdFromEntity(labsecurity['labpatrol'][k])
        SetNetworkIdCanMigrate(networkID, true)
        SetNetworkIdExistsOnAllMachines(networkID, true)
        SetPedRandomComponentVariation(labsecurity['labpatrol'][k], 0)
        SetPedRandomProps(labsecurity['labpatrol'][k])
        SetEntityAsMissionEntity(labsecurity['labpatrol'][k])
        SetEntityVisible(labsecurity['labpatrol'][k], true)
        SetPedRelationshipGroupHash(labsecurity['labpatrol'][k], `labpatrol`)
        SetPedAccuracy(labsecurity['labpatrol'][k], Config.LabGuardAccuracy)
        SetPedArmour(labsecurity['labpatrol'][k], 100)
        SetPedCanSwitchWeapon(labsecurity['labpatrol'][k], true)
        SetPedDropsWeaponsWhenDead(labsecurity['labpatrol'][k], false)
        SetPedFleeAttributes(labsecurity['labpatrol'][k], 0, false)
        GiveWeaponToPed(labsecurity['labpatrol'][k], randomgun, 999, false, false)
        TaskGoToEntity(labsecurity['labpatrol'][k], PlayerPedId(), -1, 1.0, 10.0, 1073741824.0, 0)
        local random = math.random(1, 2)
        if random == 2 then
            TaskGuardCurrentPosition(labsecurity['labpatrol'][k], 10.0, 10.0, 1)
        end
    end

    SetRelationshipBetweenGroups(0, `labpatrol`, `labpatrol`)
    SetRelationshipBetweenGroups(5, `labpatrol`, `PLAYER`)
    SetRelationshipBetweenGroups(5, `PLAYER`, `labpatrol`)
end

function ExportLabTarget1()
    exports['qb-target']:AddBoxZone("hack-lab1", labcoords1, 1, 1, {
        name="hack-lab1",
        heading=350,
        debugpoly = Config.DebugPoly,
    }, {
        options = {
            {
                type = "client",
                event = "qb-miniheists:StartLabHack",
                icon = "far fa-usb",
                label = "Hack Research Files",
                item = Config.HackItem,
            },
        },
        distance = 2.0
    })
end

function ExportLabTarget2()
    exports['qb-target']:AddBoxZone("hack-lab2", labcoords2, 3, 3, {
        name="hack-lab2",
        heading=170,
        debugpoly = Config.DebugPoly,
    }, {
        options = {
            {
                type = "client",
                event = "qb-miniheists:StartLabHack2",
                icon = "far fa-usb",
                label = "Steal Samples",
            },
        },
        distance = 2.0
    })
end 

function ExportSecurityTarget()
    exports['qb-target']:AddBoxZone("sec-target-bypass", vector3(3605.52, 3636.59, 41.34), 3, 3, {
        name="sec-target-bypass",
        heading=262,
        debugpoly = Config.DebugPoly,
    }, {
        options = {
            {
                type = "client",
                event = "qb-miniheists:BypassLabGuardAlarm",
                icon = "fas fa-shield",
                label = "Bypass Security(1 Shot)",
                item = Config.HackItem,
            },
        },
        distance = 2.0
    })
end

function RemoveLabTarget1()
    exports['qb-target']:RemoveZone("hack-lab1")
end

function RemoveLabTarget2()
    exports['qb-target']:RemoveZone("hack-lab2")
end

function RemoveLabBypass()
    exports['qb-target']:RemoveZone("sec-target-bypass")
end

-- MW Raid Stuff WIP ------------------------------------------------------------------------------------------

RegisterNetEvent('qb-miniheists:StartMWRaid', function()
    if GotJob == false then
        TriggerEvent('animations:client:EmoteCommandStart', {"wait"})
            QBCore.Functions.Progressbar('pickup', 'Getting Job...', 5000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function()
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                QBCore.Functions.Notify('You will be emailed shortly with the location', 'primary')
                if CurrentCops >= Config.MinimumPolice then
                    Wait(EmailTime)
                    TriggerServerEvent('qb-phone:server:sendNewMail', {
                    sender = 'Frank Castle',
                    subject = 'Top Secret Documents...',
                    message = 'Heres the location. you will need to hack each terminal in the office until you gain access to the locked pc. <br/> watch out for the guards. take friends with you and lots of guns!',
                    })
                    SetNewWaypoint(mwcoords)
                    ExportMW1Target()
                else
                    QBCore.Functions.Notify('Not enough police presence', 'error', 3000)
                end
            end)
        else
        QBCore.Functions.Notify('You Already Have a Job', 'error', 3000)
    end
end)

RegisterNetEvent('qb-miniheists:MWHack1', function()
    if QBCore.Functions.HasItem(Config.HackItem) then
        TriggerEvent('animations:client:EmoteCommandStart', {"type"})
        QBCore.Functions.Progressbar('cnct_elect', 'Installing Sub-Routines...', HackingTime, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function()
        end)
        Wait(HackingTime)
        TriggerEvent('animations:client:EmoteCommandStart', {"type"})
        exports['ps-ui']:Scrambler(function(success)
            if success then
                Wait(100)
                TriggerEvent('animations:client:EmoteCommandStart', {"type"})
                Wait(500)
                QBCore.Functions.Progressbar('po_usb', 'Rerouting Controls..', HackingTime, false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {}, {}, {}, function()
                end)
                Wait(HackingTime)
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                SpawnGuardsMW()
                QBCore.Functions.Notify('You switched controls to a new terminal, find it!', 'primary', 8000)
                Wait(7500)
                RemoveMW1Target()
                ExportMW2Target()
            else
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                QBCore.Functions.Notify('You failed Hacking, try again', 'error', 5000)
                SpawnGuardsMW()
            end
        end, Config.MWHackType, Config.MWHackTime, 0)
    else
        QBCore.Functions.Notify('You dont have the hack device', 'error', 3000)
    end
end)

RegisterNetEvent('qb-miniheists:MWHack2', function()
    if QBCore.Functions.HasItem(Config.HackItem) then
        TriggerEvent('animations:client:EmoteCommandStart', {"type"})
        QBCore.Functions.Progressbar('cnct_elect', 'Installing Sub-Routines...', HackingTime, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function()
        end)
        Wait(HackingTime)
        TriggerEvent('animations:client:EmoteCommandStart', {"type"})
        exports['ps-ui']:Scrambler(function(success)
            if success then
                Wait(100)
                TriggerEvent('animations:client:EmoteCommandStart', {"type"})
                Wait(500)
                QBCore.Functions.Progressbar('po_usb', 'Rerouting Controls..', HackingTime, false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {}, {}, {}, function()
                end)
                Wait(HackingTime)
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                SpawnGuardsMW()
                QBCore.Functions.Notify('You switched controls to a new terminal, find it!', 'primary', 8000)
                Wait(7500)
                RemoveMW2Target()
                ExportMW3Target()
            else
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                QBCore.Functions.Notify('You failed Hacking, try again', 'error', 5000)
                SpawnGuardsMW()
            end
        end, Config.MWHackType, Config.MWHackTime, 0)
    else
        QBCore.Functions.Notify('You dont have the hack device', 'error', 3000)
    end
end)

RegisterNetEvent('qb-miniheists:MWHack3', function()
    if QBCore.Functions.HasItem(Config.HackItem) then
        TriggerEvent('animations:client:EmoteCommandStart', {"type"})
        QBCore.Functions.Progressbar('cnct_elect', 'Installing Sub-Routines...', HackingTime, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function()
        end)
        Wait(HackingTime)
        TriggerEvent('animations:client:EmoteCommandStart', {"type"})
        exports['ps-ui']:Scrambler(function(success)
            if success then
                Wait(100)
                TriggerEvent('animations:client:EmoteCommandStart', {"type"})
                Wait(500)
                QBCore.Functions.Progressbar('po_usb', 'Rerouting Controls..', HackingTime, false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {}, {}, {}, function()
                end)
                Wait(HackingTime)
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                SpawnGuardsMW()
                QBCore.Functions.Notify('You switched controls to a new terminal, find it!', 'primary', 8000)
                Wait(7500)
                RemoveMW3Target()
                ExportMW4Target()
            else
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                QBCore.Functions.Notify('You failed Hacking, try again', 'error', 5000)
                SpawnGuardsMW()
            end
        end, Config.MWHackType, Config.MWHackTime, 0)
    else
        QBCore.Functions.Notify('You dont have the hack device', 'error', 3000)
    end
end)

RegisterNetEvent('qb-miniheists:MWHack4', function()
    if QBCore.Functions.HasItem(Config.HackItem) then
        TriggerEvent('animations:client:EmoteCommandStart', {"type"})
        QBCore.Functions.Progressbar('cnct_elect', 'Installing Sub-Routines...', HackingTime, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function()
        end)
        Wait(HackingTime)
        TriggerEvent('animations:client:EmoteCommandStart', {"type"})
        exports['ps-ui']:Scrambler(function(success)
            if success then
                Wait(100)
                TriggerEvent('animations:client:EmoteCommandStart', {"type"})
                Wait(500)
                QBCore.Functions.Progressbar('po_usb', 'Rerouting Controls..', HackingTime, false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {}, {}, {}, function()
                end)
                Wait(HackingTime)
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                SpawnGuardsMW()
                QBCore.Functions.Notify('You switched controls to a new terminal, find it!', 'primary', 8000)
                Wait(7500)
                RemoveMW4Target()
                ExportMW5Target()
            else
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                QBCore.Functions.Notify('You failed Hacking, try again', 'error', 5000)
                SpawnGuardsMW()
            end
        end, Config.MWHackType, Config.MWHackTime, 0)
    else
        QBCore.Functions.Notify('You dont have the hack device', 'error', 3000)
    end
end)

RegisterNetEvent('qb-miniheists:MWHack5', function()
    if QBCore.Functions.HasItem(Config.HackItem) then
        TriggerEvent('animations:client:EmoteCommandStart', {"type"})
        QBCore.Functions.Progressbar('cnct_elect', 'Installing Sub-Routines...', HackingTime, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function()
        end)
        Wait(HackingTime)
        TriggerEvent('animations:client:EmoteCommandStart', {"type"})
        exports['ps-ui']:Scrambler(function(success)
            if success then
                Wait(100)
                TriggerEvent('animations:client:EmoteCommandStart', {"type"})
                Wait(500)
                QBCore.Functions.Progressbar('po_usb', 'Rerouting Controls..', HackingTime, false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {}, {}, {}, function()
                end)
                Wait(HackingTime)
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                SpawnGuardsMW()
                QBCore.Functions.Notify('You switched controls to a new terminal, find it!', 'primary', 8000)
                Wait(7500)
                RemoveMW5Target()
                ExportMWFinalTarget()
            else
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                QBCore.Functions.Notify('You failed Hacking, try again', 'error', 5000)
                SpawnGuardsMW()
            end
        end, Config.MWHackType, Config.MWHackTime, 0)
    else
        QBCore.Functions.Notify('You dont have the hack device', 'error', 3000)
    end
end)

RegisterNetEvent('qb-miniheists:MWHackFinal', function()
    if QBCore.Functions.HasItem(Config.HackItem) then
        TriggerEvent('animations:client:EmoteCommandStart', {"type"})
        QBCore.Functions.Progressbar('cnct_elect', 'Braking Final Firewall...', HackingTime, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function()
        end)
        Wait(HackingTime)
        TriggerEvent('animations:client:EmoteCommandStart', {"type"})
        exports['ps-ui']:Scrambler(function(success)
            if success then
                Wait(100)
                TriggerEvent('animations:client:EmoteCommandStart', {"type"})
                Wait(500)
                QBCore.Functions.Progressbar('po_usb', 'Downloading Top Secret Files..', HackingTime, false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {}, {}, {}, function()
                end)
                Wait(HackingTime)
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                TriggerServerEvent('qb-miniheists:MWFinalDone')
                SpawnGuardsMW()
                QBCore.Functions.Notify('You downloaded the file, now take it back!', 'primary', 8000)
                Wait(7500)
                RemoveMWFinalTarget()
            else
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                QBCore.Functions.Notify('You failed Hacking, try again', 'error', 5000)
                SpawnGuardsMW()
            end
        end, Config.MWHackType, Config.MWHackTime, 0)
    else
        QBCore.Functions.Notify('You dont have the hack device', 'error', 3000)
    end
end)

MWsecurity = {
    ['mwpatrol'] = {}
}

function loadModel(model)
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

function SpawnGuardsMW()
    local ped = PlayerPedId()
    local randomgun = Config.MWGuardWeapon[math.random(1, #Config.MWGuardWeapon)]

    SetPedRelationshipGroupHash(ped, `PLAYER`)
    AddRelationshipGroup('mwpatrol')

    for k, v in pairs(Config['MWsecurity']['mwpatrol']) do
        loadModel(v['model'])
        MWsecurity['mwpatrol'][k] = CreatePed(26, GetHashKey(v['model']), v['coords'], v['heading'], true, true)
        NetworkRegisterEntityAsNetworked(MWsecurity['mwpatrol'][k])
        networkID = NetworkGetNetworkIdFromEntity(MWsecurity['mwpatrol'][k])
        SetNetworkIdCanMigrate(networkID, true)
        SetNetworkIdExistsOnAllMachines(networkID, true)
        SetPedRandomComponentVariation(MWsecurity['mwpatrol'][k], 0)
        SetPedRandomProps(MWsecurity['mwpatrol'][k])
        SetEntityAsMissionEntity(MWsecurity['mwpatrol'][k])
        SetEntityVisible(MWsecurity['mwpatrol'][k], true)
        SetPedRelationshipGroupHash(MWsecurity['mwpatrol'][k], `mwpatrol`)
        SetPedAccuracy(MWsecurity['mwpatrol'][k], Config.MWGuardAccuracy)
        SetPedArmour(MWsecurity['mwpatrol'][k], 100)
        SetPedCanSwitchWeapon(MWsecurity['mwpatrol'][k], true)
        SetPedDropsWeaponsWhenDead(MWsecurity['mwpatrol'][k], false)
        SetPedFleeAttributes(MWsecurity['mwpatrol'][k], 0, false)
        GiveWeaponToPed(MWsecurity['mwpatrol'][k], randomgun, 999, false, false)
        TaskGoToEntity(MWsecurity['mwpatrol'][k], PlayerPedId(), -1, 1.0, 10.0, 1073741824.0, 0)
        local random = math.random(1, 2)
        if random == 2 then
            TaskGuardCurrentPosition(MWsecurity['mwpatrol'][k], 10.0, 10.0, 1)
        end
    end

    SetRelationshipBetweenGroups(0, `mwpatrol`, `mwpatrol`)
    SetRelationshipBetweenGroups(5, `mwpatrol`, `PLAYER`)
    SetRelationshipBetweenGroups(5, `PLAYER`, `mwpatrol`)
end

function ExportMW1Target()
    exports['qb-target']:AddBoxZone("mw1-hack", vector3(572.9, -3123.86, 18.74), 2, 3, {
        name="mw1-hack",
        heading=90,
        debugpoly = Config.DebugPoly,
    }, {
        options = {
            {
                type = "client",
                event = "qb-miniheists:MWHack1",
                icon = "fas fa-shield",
                label = "Install Sub-routines",
                item = Config.HackItem,
            },
        },
        distance = 2.0
    })
end

function ExportMW2Target()
    exports['qb-target']:AddBoxZone("mw2-hack", vector3(571.82, -3123.84, 18.43), 2, 3, {
        name="mw2-hack",
        heading=270,
        debugpoly = Config.DebugPoly,
    }, {
        options = {
            {
                type = "client",
                event = "qb-miniheists:MWHack2",
                icon = "fas fa-shield",
                label = "Install Sub-routines",
                item = Config.HackItem,
            },
        },
        distance = 2.0
    })
end

function ExportMW3Target()
    exports['qb-target']:AddBoxZone("mw3-hack", vector3(565.94, -3120.51, 18.74), 2, 3, {
        name="mw3-hack",
        heading=0,
        debugpoly = Config.DebugPoly,
    }, {
        options = {
            {
                type = "client",
                event = "qb-miniheists:MWHack3",
                icon = "fas fa-shield",
                label = "Install Sub-routines",
                item = Config.HackItem,
            },
        },
        distance = 2.0
    })
end

function ExportMW4Target()
    exports['qb-target']:AddBoxZone("mw4-hack", vector3(564.03, -3124.42, 18.43), 2, 3, {
        name="mw4-hack",
        heading=270,
        debugpoly = Config.DebugPoly,
    }, {
        options = {
            {
                type = "client",
                event = "qb-miniheists:MWHack4",
                icon = "fas fa-shield",
                label = "Install Sub-routines",
                item = Config.HackItem,
            },
        },
        distance = 2.0
    })
end

function ExportMW5Target()
    exports['qb-target']:AddBoxZone("mw5-hack", vector3(565.11, -3124.44, 18.74), 2, 3, {
        name="mw5-hack",
        heading=90,
        debugpoly = Config.DebugPoly,
    }, {
        options = {
            {
                type = "client",
                event = "qb-miniheists:MWHack5",
                icon = "fas fa-shield",
                label = "Install Sub-routines",
                item = Config.HackItem,
            },
        },
        distance = 2.0
    })
end

function ExportMWFinalTarget()
    exports['qb-target']:AddBoxZone("mwfinal", vector3(569.47, -3127.44, 18.57), 1, 1, {
        name="mwfinal",
        heading=173,
        debugpoly = Config.DebugPoly,
    }, {
        options = {
            {
                type = "client",
                event = "qb-miniheists:MWHackFinal",
                icon = "fas fa-hand",
                label = "Extract Files",
                item = Config.HackItem,
            },
        },
        distance = 2.0
    })
end

function RemoveMW1Target()
    exports['qb-target']:RemoveZone("mw1-hack")
end

function RemoveMW2Target()
    exports['qb-target']:RemoveZone("mw2-hack")
end

function RemoveMW3Target()
    exports['qb-target']:RemoveZone("mw3-hack")
end

function RemoveMW4Target()
    exports['qb-target']:RemoveZone("mw4-hack")
end

function RemoveMW5Target()
    exports['qb-target']:RemoveZone("mw5-hack")
end

function RemoveMWFinalTarget()
    exports['qb-target']:RemoveZone("mwfinal")
end

--car heist Stuff -------------------------------------------------------------------------------------------------

RegisterNetEvent("qb-miniheists:getJobA", function()
    if not GotJob then
        if CurrentCops >= Config.MinimumPolice then
            carmodel = Config.VehicleTierA.BoostVehicles[math.random(1, #Config.VehicleTierA.BoostVehicles)]
            location = Config.CarHeistLocations.CarSpawn[math.random(1, #Config.CarHeistLocations.CarSpawn)]
            TriggerServerEvent('qb-miniheists:GiveTierAPrice')
            print("server event done")
            TriggerServerEvent('qb-phone:server:sendNewMail', {
                sender = "Mr Lynch",
                subject = "Get This Car",
                message = "Hey Man i got a small job for you. here are the details. <br/> Location: <br/> "..location.name.."<br/> Car Model: <br/> "..carmodel.name.."<br/> And Bring it back to the crane here to load onto the ship" ,
            })
            GotJob = true
            GotJobA = true
            Finished = false
            QBCore.Functions.SpawnVehicle(carmodel.model, function(veh) end, location.coords, true)
        else
            QBCore.Functions.Notify('Not enough police presence', 'error', 7500)
        end
    else
        QBCore.Functions.Notify('You already have a Job', 'error', 7500)
    end
end)

RegisterNetEvent("qb-miniheists:getJobB", function()
    if not GotJob then
        if CurrentCops >= Config.MinimumPolice then
            carmodel = Config.VehicleTierB.BoostVehicles[math.random(1, #Config.VehicleTierB.BoostVehicles)]
            location = Config.CarHeistLocations.CarSpawn[math.random(1, #Config.CarHeistLocations.CarSpawn)]
            TriggerServerEvent('qb-miniheists:GiveTierBPrice')
            TriggerServerEvent('qb-phone:server:sendNewMail', {
                sender = "Mr Lynch",
                subject = "Get This Car",
                message = "Hey got a nice motor for you today! <br/> Location: <br/> "..location.name.."<br/> Car Model: "..carmodel.name.."<br/> And Bring it back to the crane here to load onto the ship" ,
            })
            GotJob = true
            GotJobB = true
            Finished = false
            QBCore.Functions.SpawnVehicle(carmodel.model, function(veh) end, location.coords, true)
        else
            QBCore.Functions.Notify('Not enough police presence', 'error', 7500)
        end
    else
        QBCore.Functions.Notify('You already have a Job', 'error', 7500)
    end
end)

RegisterNetEvent("qb-miniheists:getJobC", function()
    if not GotJob then
        if CurrentCops >= Config.MinimumPolice then
            carmodel = Config.VehicleTierC.BoostVehicles[math.random(1, #Config.VehicleTierC.BoostVehicles)]
            location = Config.CarHeistLocations.CarSpawn[math.random(1, #Config.CarHeistLocations.CarSpawn)]
            TriggerServerEvent('qb-miniheists:GiveTierCPrice')
            TriggerServerEvent('qb-phone:server:sendNewMail', {
                sender = "Mr Lynch",
                subject = "Get This Car",
                message = "Hey i got a real pretty ride for you today. check this out! <br/> Location: <br/> "..location.name.."<br/> Car Model: "..carmodel.name.."<br/> And Bring it back to the crane here to load onto the ship" ,
            })
            GotJob = true
            GotJobC = true
            Finished = false
            QBCore.Functions.SpawnVehicle(carmodel.model, function(veh) end, location.coords, true)
        else
            QBCore.Functions.Notify('Not enough police presence', 'error', 7500)
        end
    else
        QBCore.Functions.Notify('You already have a job', 'error', 7500)
    end
end)

RegisterNetEvent("qb-miniheists:DeliverVehicleA", function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
    if not Finished and GotJob and GotJobA then
        QBCore.Functions.Progressbar('delv', 'Loading Vehicle To Ship', Config.LoadingTime*1000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function()
            TriggerServerEvent("qb-miniheists:getRewardA")
            Wait(0)
            DeleteVehicle(vehicle)
        QBCore.Functions.Notify('You Delivered The Vehicle', 'primary', 7500)
        GotJob = false
        GotJobA = false
        Finished = true
        end, function()
        QBCore.Functions.Notify('Cancelled', 'error', 7500)
        GotJob = false
        GotJobA = false
        Finished = true
        end)
     end
end)

RegisterNetEvent("qb-miniheists:DeliverVehicleB", function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
    if not Finished and GotJob and GotJobB then
        QBCore.Functions.Progressbar('delv', 'Loading Vehicle To Ship', Config.LoadingTime*1000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function()
            TriggerServerEvent("qb-miniheists:getRewardB")
            Wait(0)
            DeleteVehicle(vehicle)
        QBCore.Functions.Notify('You Delivered The Vehicle', 'primary', 7500)
        GotJob = false
        GotJobB = false
        Finished = true
        end, function()
        QBCore.Functions.Notify('Cancelled', 'error', 7500)
        GotJob = false
        GotJobB = false
        Finished = true
        end)
     end
end)

RegisterNetEvent("qb-miniheists:DeliverVehicleC", function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
    if not Finished and GotJob and GotJobC then
        QBCore.Functions.Progressbar('delv', 'Loading Vehicle To Ship', Config.LoadingTime*1000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function()
            TriggerServerEvent("qb-miniheists:getRewardC")
            Wait(0)
            DeleteVehicle(vehicle)
        QBCore.Functions.Notify('You Delivered The Vehicle', 'primary', 7500)
        GotJob = false
        GotJobC = false
        Finished = true
        end, function()
        QBCore.Functions.Notify('Cancelled', 'error', 7500)
        GotJob = false
        GotJobC = false
        Finished = true
        end)
     end
end)

RegisterNetEvent("qb-miniheists:ScrapVehicle", function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
    if not Finished and GotJob then
        print("scrapcheck")
        TriggerServerEvent('police:server:policeAlert', 'Stolen Car Sighted')
        QBCore.Functions.Progressbar('delv', 'Scrapping Vehicle', Config.ScrapTime*1000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function()
            TriggerServerEvent("qb-miniheists:GetScrapReward")
            Wait(0)
            DeleteVehicle(vehicle)
        QBCore.Functions.Notify('You Scrapped The Vehicle', 'primary', 7500)
            GotJob = false
            GotJobA = false
            GotJobB = false
            GotJobC = false
            Finished = true
        end, function()
        QBCore.Functions.Notify('Cancelled', 'error', 7500)
            GotJob = false
            GotJobA = false
            GotJobB = false
            GotJobC = false
            Finished = true
        end)
     end
end)

RegisterNetEvent('qb-miniheists:TierCheck', function()
    if not Finished and GotJobA then
        TriggerEvent('qb-miniheists:DeliverVehicleA')
    elseif not Finished and GotJobB then
        TriggerEvent('qb-miniheists:DeliverVehicleB')
    elseif not Finished and GotJobC then
        TriggerEvent('qb-miniheists:DeliverVehicleC')
    end
end)                             

Citizen.CreateThread(function()
    local inRange = false
    while true do
        Wait(0)
        local pos = GetEntityCoords(PlayerPedId())
        if #(pos - vector3(Config.CarHeistLocations["Deliver"].x, Config.CarHeistLocations["Deliver"].y, Config.CarHeistLocations["Deliver"].z)) < 10 then
            inRange = true
            if IsPedInAnyVehicle(PlayerPedId()) then
                DrawMarker(2, Config.CarHeistLocations["Deliver"].x, Config.CarHeistLocations["Deliver"].y, Config.CarHeistLocations["Deliver"].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
                if #(pos - vector3(Config.CarHeistLocations["Deliver"].x, Config.CarHeistLocations["Deliver"].y, Config.CarHeistLocations["Deliver"].z)) < 5 then
                    DrawText3D(Config.CarHeistLocations["Deliver"].x, Config.CarHeistLocations["Deliver"].y, Config.CarHeistLocations["Deliver"].z, "~g~E~w~ - Deliver Vehicle") 
                        if IsControlJustPressed(0, 38) then
                            if GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId()), -1) == PlayerPedId() then
                                if IsVehicleValid(GetEntityModel(GetVehiclePedIsIn(PlayerPedId(), true))) then
                                    TriggerEvent("qb-miniheists:TierCheck")
                                else
                                    QBCore.Functions.Notify('This is not the right vehicle', 'error', 7500)
                                end
                            else
                                QBCore.Functions.Notify('You must be the driver of the vehicle', 'error', 7500)
                            end
                        end
                end
            end
            if not inRange then
                Wait(1000)
            end
        end
    end
end)

Citizen.CreateThread(function()
    local inRange = false
    while true do
        Wait(0)
        local pos = GetEntityCoords(PlayerPedId())
        if #(pos - vector3(Config.CarHeistLocations["Scrap"].x, Config.CarHeistLocations["Scrap"].y, Config.CarHeistLocations["Scrap"].z)) < 10 then
            inRange = true
            if IsPedInAnyVehicle(PlayerPedId()) then
                DrawMarker(2, Config.CarHeistLocations["Scrap"].x, Config.CarHeistLocations["Scrap"].y, Config.CarHeistLocations["Scrap"].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
                if #(pos - vector3(Config.CarHeistLocations["Scrap"].x, Config.CarHeistLocations["Scrap"].y, Config.CarHeistLocations["Scrap"].z)) < 5 then
                    DrawText3D(Config.CarHeistLocations["Scrap"].x, Config.CarHeistLocations["Scrap"].y, Config.CarHeistLocations["Scrap"].z, "~g~E~w~ - Scrap Vehicle") 
                        if IsControlJustPressed(0, 38) then
                            if GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId()), -1) == PlayerPedId() then
                                if IsVehicleValid(GetEntityModel(GetVehiclePedIsIn(PlayerPedId(), true))) then
                                    TriggerEvent("qb-miniheists:ScrapVehicle")
                                else
                                    QBCore.Functions.Notify('This is not the right vehicle', 'error', 7500)
                                end
                            else
                                QBCore.Functions.Notify('You must be the driver of the vehicle', 'error', 7500)
                            end
                        end
                end
            end
            if not inRange then
                Wait(1000)
            end
        end
    end
end)

function IsVehicleValid(vehicleModel)
	local retval = false
	if carmodel ~= nil then
		if carmodel ~= nil and GetHashKey(carmodel.model) == vehicleModel then
			retval = true
		end
	end
	return retval
end

function DrawText3D(x, y, z, text)
    SetTextScale(0.3, 0.3)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 400
    DrawRect(0.0, 0.0 + 0.0110, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

RegisterNetEvent('qb-miniheists:EndHeistCommand', function()
    GotJob = false
    print(GotJob)
    Finished = true
    print(Finished)
    GotJobA = false
    print(GotJobA)
    GotJobB = false
    print(GotJobB)
    GotJobC = false
    print(GotJobC)
    carmodel = nil
    print(carmodel)
    location = nil
    print(location)
    SecurityBypass = false
    print(SecurityBypass)
    QBCore.Functions.Notify('All Heist Parameters Reset', 'success', 2000)
end)

