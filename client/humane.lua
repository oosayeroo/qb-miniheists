local QBCore = exports['qb-core']:GetCoreObject()
local GotJob = false
local Finished = true
local labcoords1 = vector3(3536.97, 3669.4, 28.12)
local labcoords2 = vector3(3559.71, 3673.84, 28.12)
local CurrentCops = 0
local SecurityBypass = false
local HackingTime = Config.HackingTime*1000
local EmailTime = Config.EmailTime*1000
local npcspawned = false

RegisterNetEvent('police:SetCopCount', function(amount)
    CurrentCops = amount
end)

Citizen.CreateThread(function()
    if Config.Target == 'ox' then
    lib.requestModel(Config.LabBossModel)
    local coords = Config.LabBossLocation
    local LabPed = CreatePed(0, 's_m_y_westsec_01', coords.x, coords.y, coords.z - 1.0, coords.w, false, false)
    FreezeEntityPosition(LabPed, true)
    SetEntityInvincible(LabPed, true)
    SetBlockingOfNonTemporaryEvents(LabPed, true)

    exports.ox_target:addSphereZone({
        coords = Config.LabBossLocation,
        radius = 1.1,
        debug = false,
        options = {
            {
                name = 'labraid',
                event = 'qb-miniheists:LabRaid',
                icon = 'fas fa-key',
                label = "Start Lab Raid",
            },
            {
                name = 'labraidpayment',
                serverEvent = 'qb-miniheists:RecievePaymentLab',
                icon = 'fas fa-hand',
                label = "Hand Over Research",
            }
        }
    })
    elseif Config.Target == 'qb' then
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
                    {type = "client",event = "qb-miniheists:LabRaid",icon = "fas fa-comment",label = "Start Lab Raid",},
                    {type = "server",event = "qb-miniheists:RecievePaymentLab",icon = "fas fa-hand",label = "HandOver Research",item = { "lab-usb","lab-samples","lab-files",},},
                },
              distance = 2.5,
            },
        })
    end
end)

--Lab Raid Stuff --------------------------------------------------------------------------------------------------

RegisterNetEvent('qb-miniheists:LabRaid', function()
    if GotJob == false then
        TriggerEvent('animations:client:EmoteCommandStart', {"wait"})
            QBCore.Functions.Progressbar('pickup', 'Getting Job...', 5000, false, true, {disableMovement = true,disableCarMovement = true,disableMouse = false,disableCombat = true,}, {}, {}, {}, function()
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                QBCore.Functions.Notify('You will be emailed shortly with the location', 'primary')
                if CurrentCops >= Config.MinimumPolice then
                    Wait(EmailTime)
                    if Config.PhoneScript == 'qb' then
                        TriggerServerEvent('qb-phone:server:sendNewMail', {sender = "Lugo Bervich",subject = "Bio Research",
                            message = "Heres the location. You Need to hack the firewall through the computer in laboratory 1 and then download the research. <br/> I will email again when I see the firewall is down!" ,
                        })
                    elseif Config.PhoneScript == 'qs' then
                        TriggerServerEvent('qs-smartphone:server:sendNewMail', {sender = 'Lugo Bervich',subject = 'Bio Research',
                            message = "Heres the location. You Need to hack the firewall through the computer in laboratory 1 and then download the research. <br/> I will email again when I see the firewall is down!",
                            button = {}
                        })
                    elseif Config.PhoneScript == 'road' then
                        TriggerServerEvent('roadphone:receiveMail', {sender = 'Lugo Bervich',subject = "Bio Research",
                            message = "Heres the location. You Need to hack the firewall through the computer in laboratory 1 and then download the research. <br/> I will email again when I see the firewall is down!",
                            image = '/public/html/static/img/icons/app/mail.png',
                            button = {}
                        })
                    elseif Config.PhoneScript == 'gks' then
                        TriggerServerEvent('gksphone:NewMail', {sender = 'Lugo Bervich',image = '/html/static/img/icons/mail.png',subject = "Bio Research",
                            message = "Heres the location. You Need to hack the firewall through the computer in laboratory 1 and then download the research. <br/> I will email again when I see the firewall is down!",
                            button = {}
                        })
                    end
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
        TriggerEvent('animations:client:EmoteCommandStart', {"type"})
        QBCore.Functions.Progressbar('cnct_elect', 'Bypassing Firewall...', HackingTime, false, true, {disableMovement = true,disableCarMovement = true,disableMouse = false,disableCombat = true,}, {}, {}, {}, function()
        end)
        Wait(HackingTime)
        TriggerEvent('animations:client:EmoteCommandStart', {"type"})
        exports['ps-ui']:Scrambler(function(success)
            if success then
                Wait(100)
                TriggerEvent('animations:client:EmoteCommandStart', {"type"})
                Wait(500)
                QBCore.Functions.Progressbar('po_usb', 'Downloading Research..', HackingTime, false, true, {disableMovement = true,disableCarMovement = true,disableMouse = false,disableCombat = true,}, {}, {}, {}, function()
                end)
                Wait(HackingTime)
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                if Config.PoliceAlertLab then
                    if Config.PoliceNofityType == 'ps' then
                    exports['ps-dispatch']:HumaneRobery()
                    elseif Config.PoliceNofityType == 'qb' then
                        TriggerServerEvent('police:server:policeAlert', 'Break in at Humane Labs, Laboratory 1!')
                    end
                end
                TriggerServerEvent('qb-miniheists:LabHackDone')
                if SecurityBypass == false then
                    TriggerServerEvent('qb-miniheists:gatherlabnpc')
                end
                QBCore.Functions.Notify('You Successfully Downloaded the Research, Wait for New Email!', 'primary', 8000)
                Wait(7500)
                if Config.PhoneScript == 'qb' then
                    TriggerServerEvent('qb-phone:server:sendNewMail', {sender = "Lugo Bervich",subject = "Bio Research...",
                        message = "Great you did it! now head to the Cold Room and bring me some samples of their work and any files you see!" ,
                    })
                elseif Config.PhoneScript == 'qs' then
                    TriggerServerEvent('qs-smartphone:server:sendNewMail', {sender = 'Lugo Bervich',subject = 'Bio Research...',
                        message = "Great you did it! now head to the Cold Room and bring me some samples of their work and any files you see!",
                        button = {}
                    })
                elseif Config.PhoneScript == 'road' then
                    TriggerServerEvent('roadphone:receiveMail', {sender = 'Lugo Bervich',subject = "Bio Research...",
                        message = "Great you did it! now head to the Cold Room and bring me some samples of their work and any files you see!",
                        image = '/public/html/static/img/icons/app/mail.png',
                        button = {}
                    })
                elseif Config.PhoneScript == 'gks' then
                    TriggerServerEvent('gksphone:NewMail', {sender = 'Lugo Bervich',image = '/html/static/img/icons/mail.png',subject = "Bio Research...",
                        message = "Great you did it! now head to the Cold Room and bring me some samples of their work and any files you see!",
                        button = {}
                    })
                end
                RemoveLabTarget1()
                ExportLabTarget2()
            else
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                QBCore.Functions.Notify('You failed Hacking, try again', 'error', 5000)
                    if SecurityBypass == false then
                        TriggerServerEvent('qb-miniheists:gatherlabnpc')
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
    QBCore.Functions.Progressbar('cnct_elect', 'Grabbing Samples and Files...', HackingTime, false, true, {disableMovement = true,disableCarMovement = true,disableMouse = false,disableCombat = true,}, {}, {}, {}, function()
    end)
    Wait(HackingTime)
    TriggerEvent('animations:client:EmoteCommandStart', {"c"})
    TriggerServerEvent('qb-miniheists:GrabSamples')
    if SecurityBypass == false then
        TriggerServerEvent('qb-miniheists:gatherlabnpc')
    end
    QBCore.Functions.Notify('You got everything, Get out of there!', 'primary', 8000)
    Wait(7500)
    if Config.PhoneScript == 'qb' then
        TriggerServerEvent('qb-phone:server:sendNewMail', {sender = "Lugo Bervich",subject = "Bio Research...",
            message = "Now Bring the Research, Samples and Files back to me for your payment!" ,
        })
    elseif Config.PhoneScript == 'qs' then
        TriggerServerEvent('qs-smartphone:server:sendNewMail', {sender = 'Lugo Bervich',subject = 'Bio Research...',
            message = "Now Bring the Research, Samples and Files back to me for your payment!",
            button = {}
        })
    elseif Config.PhoneScript == 'road' then
        TriggerServerEvent('roadphone:receiveMail', {sender = 'Lugo Bervich',subject = "Bio Research...",
            message = "Now Bring the Research, Samples and Files back to me for your payment!",
            image = '/public/html/static/img/icons/app/mail.png',
            button = {}
        })
    elseif Config.PhoneScript == 'gks' then
        TriggerServerEvent('gksphone:NewMail', {sender = 'Lugo Bervich',image = '/html/static/img/icons/mail.png',subject = "Bio Research...",
            message = "Now Bring the Research, Samples and Files back to me for your payment!",
            button = {}
        })
    end
    GotJob = false
    Finished = true
    SecurityBypass = false
    RemoveLabTarget2()
end)
  
RegisterNetEvent('qb-miniheists:BypassLabGuardAlarm', function()
    if QBCore.Functions.HasItem(Config.HackItem) then
        TriggerEvent('animations:client:EmoteCommandStart', {"type"})
        QBCore.Functions.Progressbar('cnct_elect', 'Bypassing Security Alarms...', HackingTime, false, true, {disableMovement = true,disableCarMovement = true,disableMouse = false,disableCombat = true,}, {}, {}, {}, function()
        end)
        Wait(HackingTime)
        TriggerEvent('animations:client:EmoteCommandStart', {"type"})
        exports['ps-ui']:Scrambler(function(success)
            if success then
                Wait(100)
                TriggerEvent('animations:client:EmoteCommandStart', {"type"})
                Wait(500)
                QBCore.Functions.Progressbar('po_usb', 'Rerouting Alarm Checks..', HackingTime, false, true, {disableMovement = true,disableCarMovement = true,disableMouse = false,disableCombat = true,}, {}, {}, {}, function()
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

RegisterNetEvent('qb-miniheists:SpawnLabGuards', function()
    SpawnGuardsLab()
    TriggerServerEvent('qb-miniheists:ResetGuardsLab')
end)

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
    if Config.Target == 'ox' then
    exports.ox_target:addSphereZone({
        coords = labcoords1,
        radius = 0.5,
        debug = false,
        options = {
            {
                name = 'hack-lab1',
                event = 'qb-miniheists:StartLabHack',
                icon = 'far fa-usb',
                label = "Hack Research Files",
            }
        }
    })
    elseif Config.Target == 'qb' then
    exports['qb-target']:AddBoxZone("hack-lab1", labcoords1, 1, 1, {
        name="hack-lab1",
        heading=350,
        debugpoly = Config.DebugPoly,
    }, {
        options = {
            {type = "client",event = "qb-miniheists:StartLabHack",icon = "far fa-usb",label = "Hack Research Files",item = Config.HackItem,},
        },
        distance = 2.0
    })
    end
end

function ExportLabTarget2()
    if Config.Target == 'ox' then
    exports.ox_target:addSphereZone({
        coords = labcoords2,
        radius = 0.5,
        debug = false,
        options = {
            {
                name = 'hack-lab2',
                event = 'qb-miniheists:StartLabHack2',
                icon = 'far fa-usb',
                label = "Steal Samples",
            }
        }
    })
elseif Config.Target == 'qb' then
    exports['qb-target']:AddBoxZone("hack-lab2", labcoords2, 3, 3, {
        name="hack-lab2",
        heading=170,
        debugpoly = Config.DebugPoly,
    }, {
        options = {
            {type = "client",event = "qb-miniheists:StartLabHack2",icon = "far fa-usb",label = "Steal Samples",},
        },
        distance = 2.0
    })
    end
end

function ExportSecurityTarget()
    if Config.Target == 'ox' then
    exports.ox_target:addSphereZone({
        coords = vector3(3605.52, 3636.59, 41.34),
        radius = 0.5,
        debug = false,
        options = {
            {
                name = 'sec-target-bypass',
                event = 'qb-miniheists:BypassLabGuardAlarm',
                icon = 'fas fa-shield',
                label = "Bypass Security(1 Shot)",
                item = Config.HackItem,
            }
        }
    })
elseif Config.Target == 'qb' then
    exports['qb-target']:AddBoxZone("sec-target-bypass", vector3(3605.52, 3636.59, 41.34), 3, 3, {
        name="sec-target-bypass",
        heading=262,
        debugpoly = Config.DebugPoly,
    }, {
        options = {
            {type = "client",event = "qb-miniheists:BypassLabGuardAlarm",icon = "fas fa-shield",label = "Bypass Security(1 Shot)",item = Config.HackItem,},
        },
        distance = 2.0
    })
    end
end

function RemoveLabTarget1()
    if Config.Target == 'ox' then
        exports.ox_target:removeZone("hack-lab1")
    elseif Config.Target == 'qb' then
        exports['qb-target']:RemoveZone("hack-lab1")
    end
end

function RemoveLabTarget2()
    if Config.Target == 'ox' then
        exports.ox_target:removeZone("hack-lab2")
    elseif Config.Target == 'qb' then
        exports['qb-target']:RemoveZone("hack-lab2")
    end
end

function RemoveLabBypass()
    if Config.Target == 'ox' then
        exports.ox_target:removeZone("sec-target-bypass")
    elseif Config.Target == '1b' then
        exports['qb-target']:RemoveZone("sec-target-bypass")
    end
end
