local QBCore = exports['qb-core']:GetCoreObject()
local MoneyType = Config.MoneyType
local labnpcsspawned = false
local mwnpcsspawned = false

RegisterServerEvent("qb-miniheists:gatherlabnpc")
AddEventHandler("qb-miniheists:gatherlabnpc", function()
    if labnpcsspawned == false then
		local _source = source
		TriggerClientEvent("qb-miniheists:SpawnLabGuards", _source)
		labnpcsspawned = true
	end
end)

RegisterServerEvent("qb-miniheists:gathermwnpc")
AddEventHandler("qb-miniheists:gathermwnpc", function() 
    if mwnpcsspawned == false then
		local _source = source
		TriggerClientEvent("qb-miniheists:SpawnMWGuards", _source)
		mwnpcsspawned = true
	end
end)

RegisterNetEvent('qb-miniheists:ResetGuardsMW', function()
    if mwnpcsspawned == true then
        mwnpcsspawned = false
    end
end)

RegisterNetEvent('qb-miniheists:ResetGuardsLab', function()
    if labnpcsspawned == true then
        labnpcsspawned = false
    end
end)

RegisterNetEvent('qb-miniheists:LabHackDone', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    Player.Functions.RemoveItem(Config.HackItem, 1)
    Player.Functions.AddItem('lab-usb', 1)
end)

RegisterNetEvent('qb-miniheists:MWFinalDone', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    Player.Functions.RemoveItem(Config.HackItem, 1)
    Player.Functions.AddItem('mw-usb', 1)
end)

RegisterNetEvent('qb-miniheists:GrabSamples', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.AddItem('lab-samples', 1)
    Player.Functions.AddItem('lab-files', 1)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['lab-samples'], 'add')
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['lab-files'], 'add')
end)

RegisterNetEvent('qb-miniheists:RecievePaymentLab', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local required1 = 'lab-usb'
    local required2 = 'lab-samples'
    local required3 = 'lab-files'
    local item = Config.LabRewards[math.random(1, #Config.LabRewards)]
    local amount = Config.LabRewardAmount
    local chance = math.random(100)
    
    Player.Functions.RemoveItem(required1, 1)
    Player.Functions.RemoveItem(required2, 1)
    Player.Functions.RemoveItem(required3, 1)
    Player.Functions.AddMoney(MoneyType, math.random(Config.PaymentLabMin, Config.PaymentLabMax))
    
    if chance<=Config.LabItemChance then
        Player.Functions.AddItem(item, amount)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'add')
    end
end)

RegisterNetEvent('qb-miniheists:ReceivePaymentMW', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local required = 'mw-usb'
    local item = Config.MWRewards[math.random(1, #Config.MWRewards)]
    local amount = Config.MWRewardAmount
    local chance = math.random(100)
    
    Player.Functions.RemoveItem(required, 1)
    Player.Functions.AddMoney(MoneyType, math.random(Config.PaymentMWMin, Config.PaymentMWMax))
    
    if chance<=Config.MWItemChance then
        Player.Functions.AddItem(item, amount)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'add')
    end
end)

---=====CARHEISTS STUFF=====---

RegisterNetEvent('qb-miniheists:GiveTierAPrice', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local payment = Config.TierAPrice

    Player.Functions.AddMoney(MoneyType, payment)
end)

RegisterNetEvent('qb-miniheists:GiveTierBPrice', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local payment = Config.TierBPrice

    Player.Functions.AddMoney(MoneyType, payment)
end)

RegisterNetEvent('qb-miniheists:GiveTierCPrice', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local payment = Config.TierCPrice

    Player.Functions.AddMoney(MoneyType, payment)
end)

RegisterNetEvent("qb-miniheists:getRewardA", function()
    local amount = Config.TierAReward
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.AddMoney(MoneyType, amount)
end)

RegisterNetEvent("qb-miniheists:getRewardB", function()
    local amount = Config.TierBReward
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.AddMoney(MoneyType, amount)
end)

RegisterNetEvent("qb-miniheists:getRewardC", function()
    local amount = Config.TierCReward
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.AddMoney(MoneyType, amount)
end)

RegisterNetEvent("qb-miniheists:GetScrapReward", function()
    local Player = QBCore.Functions.GetPlayer(source)
    local amount = Config.ScrapItemAmount
    local item = Config.ScrapItems[math.random(1, #Config.ScrapItems)]
    Player.Functions.AddItem(item, amount)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'add')
    if Config.GiveScrapMoney then
        local moneyamount = math.random(Config.ScrapMoneyLow, Config.ScrapMoneyMax)
        Player.Functions.AddMoney('cash', moneyamount)
    end
end)

QBCore.Commands.Add("resetheists", "resets heist parameters", {}, false, function(source) 
    TriggerClientEvent("qb-miniheists:EndHeistCommand", source, false) 
end)

RegisterNetEvent('qb-miniheists:SendServerMail', function(sender,subject,msg)
    if Config.PhoneScript == 'lb' then
        local number = exports["lb-phone"]:GetEquippedPhoneNumber(source)
        if number ~= nil then
            exports["lb-phone"]:SendMail({
                to = number,
                subject = subject,
                message = msg,
            })
        end
    end
end)