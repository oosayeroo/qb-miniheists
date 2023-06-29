local QBCore = exports['qb-core']:GetCoreObject()
local GotJob = false
local Finished = true
local mwcoords = vector3(572.9, -3123.86, 18.74)
local MWHacksDone = 0
local CurrentCops = 0
local HackingTime = Config.HackingTime*1000
local EmailTime = Config.EmailTime*1000
local npcspawned = false

RegisterNetEvent('police:SetCopCount', function(amount)
    CurrentCops = amount
end)

Citizen.CreateThread(function()
    if Config.Target == 'ox' then
        lib.requestModel(Config.MWBossModel)
        local coords = Config.MWBossLocation
        local MWPed = CreatePed(0, 'g_f_y_vagos_01', coords.x, coords.y, coords.z - 1.0, coords.w, false, false)
        FreezeEntityPosition(MWPed, true)
        SetEntityInvincible(MWPed, true)
        SetBlockingOfNonTemporaryEvents(MWPed, true)
    
        exports.ox_target:addSphereZone({
            coords = Config.MWBossLocation,
            radius = 0.5,
            debug = false,
            options = {
                {
                    name = 'mwraid',
                    event = 'qb-miniheists:StartMWRaid',
                    icon = 'fas fa-key',
                    label = "Start MerryWeather Raid",
                },
                {
                    name = 'mwraidpayment',
                    serverEvent = 'qb-miniheists:ReceivePaymentMW',
                    icon = 'fas fa-hand',
                    label = "Recieve Payment",
                }
            }
        })
elseif Config.Target == 'qb' then 
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
                {type = "client",event = "qb-miniheists:StartMWRaid",icon = "fas fa-comment",label = "Start MerryWeather Raid",},
                {type = "server",event = "qb-miniheists:ReceivePaymentMW",icon = "fas fa-hand",label = "Receive Payment",item = "mw-usb",},
            },
          distance = 2.5,
        },
    })
    end
end)

-- MW Raid Stuff WIP ------------------------------------------------------------------------------------------

RegisterNetEvent('qb-miniheists:StartMWRaid', function()
    if GotJob == false then
        TriggerEvent('animations:client:EmoteCommandStart', {"wait"})
            QBCore.Functions.Progressbar('pickup', 'Getting Job...', 5000, false, true, {disableMovement = true,disableCarMovement = true,disableMouse = false,disableCombat = true,}, {}, {}, {}, function()
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                QBCore.Functions.Notify('You will be emailed shortly with the location', 'primary')
                if CurrentCops >= Config.MinimumPolice then
                    Wait(EmailTime)
                    if Config.PhoneScript == 'qb' then
                        TriggerServerEvent('qb-phone:server:sendNewMail', {sender = "Frank Castle",subject = "Top Secret Documents...",
                            message = "Heres the location. you will need to hack each terminal in the office until you gain access to the locked pc. <br/> watch out for the guards. take friends with you and lots of guns!" ,
                        })
                    elseif Config.PhoneScript == 'qs' then
                        TriggerServerEvent('qs-smartphone:server:sendNewMail', {sender = 'Frank Castle',subject = 'Top Secret Documents...',
                            message = "Heres the location. you will need to hack each terminal in the office until you gain access to the locked pc. <br/> watch out for the guards. take friends with you and lots of guns!",
                            button = {}
                        })
                    elseif Config.PhoneScript == 'road' then
                        TriggerServerEvent('roadphone:receiveMail', {sender = 'Frank Castle',subject = "Top Secret Documents...",
                            message = "Heres the location. you will need to hack each terminal in the office until you gain access to the locked pc. <br/> watch out for the guards. take friends with you and lots of guns!",
                            image = '/public/html/static/img/icons/app/mail.png',
                            button = {}
                        })
                    elseif Config.PhoneScript == 'gks' then
                        TriggerServerEvent('gksphone:NewMail', {sender = 'Frank Castle',image = '/html/static/img/icons/mail.png',subject = "Top Secret Documents...",
                            message = "Heres the location. you will need to hack each terminal in the office until you gain access to the locked pc. <br/> watch out for the guards. take friends with you and lots of guns!",
                            button = {}
                        })
                    end
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
        QBCore.Functions.Progressbar('cnct_elect', 'Installing Sub-Routines...', HackingTime, false, true, {disableMovement = true,disableCarMovement = true,disableMouse = false,disableCombat = true,}, {}, {}, {}, function()
        end)
        Wait(HackingTime)
        TriggerEvent('animations:client:EmoteCommandStart', {"type"})
        exports['ps-ui']:Scrambler(function(success)
            if success then
                Wait(100)
                TriggerEvent('animations:client:EmoteCommandStart', {"type"})
                Wait(500)
                QBCore.Functions.Progressbar('po_usb', 'Rerouting Controls..', HackingTime, false, true, {disableMovement = true,disableCarMovement = true,disableMouse = false,disableCombat = true,}, {}, {}, {}, function()
                end)
                Wait(HackingTime)
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                TriggerServerEvent('qb-miniheists:gathermwnpc')
                QBCore.Functions.Notify('You switched controls to a new terminal, find it!', 'primary', 8000)
                Wait(7500)
                MWHacksDone = MWHacksDone+1
                if MWHacksDone < 5 then
                    RemoveMW1Target()
                    ExportMW1Target()
                elseif MWHacksDone == 5 then
                    RemoveMW1Target()
                    ExportMWFinalTarget()
                end
            else
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                QBCore.Functions.Notify('You failed Hacking, try again', 'error', 5000)
                if Config.PoliceAlertMW then
                    if Config.PoliceNofityType == 'ps' then
                        exports['ps-dispatch']:MerryweatherRobbery()
                    elseif Config.PoliceAlertType == 'qb' then
                    TriggerServerEvent('police:server:policeAlert', 'Hack Detected at Merryweather Warehouse!')
                    end
                end
                TriggerServerEvent('qb-miniheists:gathermwnpc')
            end
        end, Config.MWHackType, Config.MWHackTime, 0)
    else
        QBCore.Functions.Notify('You dont have the hack device', 'error', 3000)
    end
end)

RegisterNetEvent('qb-miniheists:MWHackFinal', function()
    if QBCore.Functions.HasItem(Config.HackItem) then
        TriggerEvent('animations:client:EmoteCommandStart', {"type"})
        QBCore.Functions.Progressbar('cnct_elect', 'Braking Final Firewall...', HackingTime, false, true, {disableMovement = true,disableCarMovement = true,disableMouse = false,disableCombat = true,}, {}, {}, {}, function()
        end)
        Wait(HackingTime)
        TriggerEvent('animations:client:EmoteCommandStart', {"type"})
        exports['ps-ui']:Scrambler(function(success)
            if success then
                Wait(100)
                TriggerEvent('animations:client:EmoteCommandStart', {"type"})
                Wait(500)
                QBCore.Functions.Progressbar('po_usb', 'Downloading Top Secret Files..', HackingTime, false, true, {disableMovement = true,disableCarMovement = true,disableMouse = false,disableCombat = true,}, {}, {}, {}, function()
                end)
                Wait(HackingTime)
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                TriggerServerEvent('qb-miniheists:MWFinalDone')
                TriggerServerEvent('qb-miniheists:gathermwnpc')
                QBCore.Functions.Notify('You downloaded the file, now take it back!', 'primary', 8000)
                Wait(7500)
                RemoveMWFinalTarget()
                MWHacksDone = 0
            else
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                QBCore.Functions.Notify('You failed Hacking, try again', 'error', 5000)
                TriggerServerEvent('qb-miniheists:gathermwnpc')
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

RegisterNetEvent('qb-miniheists:SpawnMWGuards', function()
    SpawnGuardsMW()
    TriggerServerEvent('qb-miniheists:ResetGuardsMW')
end)

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
    if MWHacksDone == 0 then
        mwloc = vector3(572.9, -3123.86, 18.74)
    elseif MWHacksDone == 1 then
        mwloc = vector3(571.82, -3123.84, 18.43)
    elseif MWHacksDone == 2 then
        mwloc = vector3(565.94, -3120.51, 18.74)
    elseif MWHacksDone == 3 then
        mwloc = vector3(564.03, -3124.42, 18.43)
    elseif MWHacksDone == 4 then
        mwloc = vector3(565.11, -3124.44, 18.74)
    end
    if Config.Target == 'ox' then
        exports.ox_target:addSphereZone({
            coords = mwcoords,
            radius = 0.5,
            debug = false,
            options = {
                {
                    name = 'mw1-hack',
                    event = 'qb-miniheists:MWHack1',
                    icon = 'fas fa-shield',
                    label = "Install Sub-Routines",
                }
            }
        })
    elseif Config.Target == 'qb' then
    exports['qb-target']:AddBoxZone("mw1-hack", mwcoords, 2, 2, {
        name="mw1-hack",
        heading=90,
        debugpoly = Config.DebugPoly,
    }, {
        options = {
            {type = "client",event = "qb-miniheists:MWHack1",icon = "fas fa-shield",label = "Install Sub-routines",item = Config.HackItem,},
        },
        distance = 2.0
    })
    end
end


function ExportMWFinalTarget()
    if Config.Target == 'ox' then
        exports.ox_target:addSphereZone({
            coords = vector3(569.47, -3127.44, 18.57),
            radius = 0.5,
            debug = false,
            options = {
                {
                    name = 'mw1-hack',
                    event = 'qb-miniheists:MWHackFinal',
                    icon = 'fas fa-hand',
                    label = "Extract Files",
                }
            }
        })
    elseif Config.Target == 'qb' then
    exports['qb-target']:AddBoxZone("mwfinal", vector3(569.47, -3127.44, 18.57), 1, 1, {
        name="mwfinal",
        heading=173,
        debugpoly = Config.DebugPoly,
    }, {
        options = {
            {type = "client",event = "qb-miniheists:MWHackFinal",icon = "fas fa-hand",label = "Extract Files",item = Config.HackItem,},
        },
        distance = 2.0
    })
    end
end

function RemoveMW1Target()
    if Config.Target == 'ox' then
        exports.ox_target:removeZone("mw1-hack")
    elseif Config.Target == 'qb' then
        exports['qb-target']:RemoveZone("mw1-hack")
    end
end

function RemoveMWFinalTarget()
    if Config.Target == 'ox' then
        exports.ox_target:removeZone("mwfinal")
    elseif Config.Target == 'qb' then
        exports['qb-target']:RemoveZone("mwfinal")
    end
end
