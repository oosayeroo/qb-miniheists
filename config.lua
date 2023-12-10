Config = {}

--===PHONE SETTINGS===--
Config.PhoneScript = 'qb'
-- qb = qb-phone
-- qs = quasar smartphone
-- road = roadphone
-- gks = gks phone
-- lb = lb-phone

Config.DebugHeists = false -- true for testing
Config.DebugPoly = true
Config.AddEndJobCommand = true --adds slash commands to end a job if someone gets bugged out

Config.MinimumPolice = 0 --change this to whatever you like
Config.PoliceAlertLab = true
Config.PoliceAlertMW = true
Config.MoneyType = 'cash'  -- cash/bank/blackmoney   -- whatever your server uses
Config.EmailTime = 30 --how many seconds after accepting job before you ge the email for it

--====Hack stuff====--

Config.HackItem = 'electronickit' -- item used to hack things you are free to change it to whatever you want
Config.LabHackType = 'alphabet' -- can be alphabet, numeric, alphanumeric, greek, braille, runes
Config.LabHackTime = 30 --how long to do minigame
Config.MWHackType = 'greek'
Config.MWHackTime = 30
Config.BypassHackTime = 10 -- minigame timer for 1 shot to bypass security at secret location to stop guards from spawning inside lab
Config.HackingTime = 30 --how long for hacking progressbars

---====LAB RAID STUFF====--

Config.LabBossModel = 's_m_y_westsec_01' --change this to whtever
Config.LabBossLocation = vector4(-461.76, 1101.05, 327.68, 138.77) -- change it you like
Config.LabBossScenario = 'WORLD_HUMAN_SMOKING' --the animation the ped does

Config.PaymentLabMin = 100 
Config.PaymentLabMax = 200 
Config.LabItemChance = 5 --in % chance you will get on of th items below on completing lab raid
Config.LabRewards = {  --rare items add as many as you like
    'lockpick', 
    'tosti',
    'water_bottle',
}
Config.LabRewardAmount = 2 -- how many of the rare item you receive

---====LAB GUARDS====---
Config.LabGuardAccuracy = 75 --out of 100 how accurate guards are
Config.LabGuardWeapon = { --this must be the weapon hash not just the weapon item name --this randomises between different guns everytime the guards are spawned
    `WEAPON_PISTOL`,
    `WEAPON_COMBATPDW`,
}

Config['labsecurity'] = {
    ['labpatrol'] = {
        { coords = vector3(3532.46, 3649.46, 27.52), heading = 63.5, model = 's_m_m_fiboffice_02'},
        { coords = vector3(3537.36, 3645.83, 28.13), heading = 46.35, model = 's_m_m_fiboffice_02'},
        { coords = vector3(3546.64, 3642.28, 28.12), heading = 96.74, model = 's_m_m_fiboffice_02'},
        { coords = vector3(3550.22, 3654.24, 28.12), heading = 156.29, model = 's_m_m_fiboffice_02'},
        { coords = vector3(3554.83, 3661.73, 28.12), heading = 21.64, model = 's_m_m_fiboffice_02'},
        { coords = vector3(3557.54, 3674.59, 28.12), heading = 104.25, model = 's_m_m_fiboffice_02'},
        { coords = vector3(3564.64, 3682.23, 28.12), heading = 48.35, model = 's_m_m_fiboffice_02'},
        { coords = vector3(3594.74, 3686.06, 27.62), heading = 124.5, model = 's_m_m_fiboffice_02'},
        { coords = vector3(3593.82, 3712.27, 29.69), heading = 139.73, model = 's_m_m_fiboffice_02'},
        { coords = vector3(3608.93, 3729.39, 29.69), heading = 323.56, model = 's_m_m_fiboffice_02'},
        { coords = vector3(3618.91, 3722.51, 29.69), heading = 85.71, model = 's_m_m_fiboffice_02'},
        { coords = vector3(3596.07, 3703.44, 29.69), heading = 344.89, model = 's_m_m_fiboffice_02'},
    },
}

---====MW RAID STUFF====--

Config.MWBossModel = 'g_f_y_vagos_01'
Config.MWBossLocation = vector4(-1078.33, -1678.27, 4.58, 300.24)
Config.MWBossScenario = 'WORLD_HUMAN_SMOKING'

Config.PaymentMWMin = 200
Config.PaymentMWMax = 300
Config.MWItemChance = 5 --in % chance of getting random item from below
Config.MWRewards = {
    'lockpick', 
    'tosti',
    'water_bottle',
}
Config.MWRewardAmount = 2

--====MW GUARDS====--
Config.MWGuardAccuracy = 75
Config.MWGuardWeapon = { --this must be the weapon hash not just the weapon item name --this randomises between different guns everytime the guards are spawned
`WEAPON_CARBINERIFLE`,
`WEAPON_COMBATPDW`,
}

Config['MWsecurity'] = {
    ['mwpatrol'] = {
        { coords = vector3(468.27, -3125.76, 6.07), heading = 265.0, model = 's_m_y_blackops_01'},
        { coords = vector3(469.19, -3118.1, 6.07), heading = 265.0, model = 's_m_y_blackops_02'},
        { coords = vector3(503.57, -3121.22, 6.07), heading = 175.0, model = 's_m_y_blackops_01'},
        { coords = vector3(503.18, -3122.46, 9.79), heading = 187.0, model = 's_m_y_blackops_02'},
        { coords = vector3(503.97, -3121.17, 9.79), heading = 187.0, model = 's_m_y_marine_03'},
        { coords = vector3(526.71, -3118.95, 8.1), heading = 187.0, model = 's_m_y_marine_03'},
        { coords = vector3(546.31, -3155.98, 6.07), heading = 187.0, model = 's_m_y_blackops_01'},
        { coords = vector3(545.82, -3182.35, 6.07), heading = 187.0, model = 's_m_y_marine_03'},
        { coords = vector3(545.97, -3141.8, 6.07), heading = 187.0, model = 's_m_y_marine_03'},
        { coords = vector3(557.99, -3123.48, 6.07), heading = 187.0, model = 's_m_y_blackops_02'},
        { coords = vector3(567.94, -3112.1, 10.97), heading = 187.0, model = 's_m_y_blackops_01'},
        { coords = vector3(592.17, -3157.41, 6.07), heading = 187.0, model = 's_m_y_marine_03'},
        { coords = vector3(592.01, -3185.52, 6.07), heading = 187.0, model = 's_m_y_blackops_01'},
        { coords = vector3(581.34, -3182.37, 6.07), heading = 187.0, model = 's_m_y_blackops_02'},
    },
}


--====CAR HEIST STUFF====--

Config.CarBossModel = 'g_m_importexport_01'
Config.CarBossLocation = vector4(-414.51, -2640.67, 6.0, 228.26)
Config.CarBossScenario = 'WORLD_HUMAN_DRUG_DEALER'
--//COSTS//--
Config.TierAPrice = math.random(200, 400)  --price of taking the job
Config.TierBPrice = math.random(400, 600) --price of taking the job
Config.TierCPrice = math.random(600, 800) --price of taking the job

--//REWARDS//--
Config.TierAReward = math.random(500, 600) --change to whatever reward value you want per car
Config.TierBReward = math.random(600, 800) --change to whatever reward value you want per car
Config.TierCReward = math.random(800, 1000) --change to whatever reward value you want per car

Config.LoadingTime = 30
Config.ScrapTime = 30 

Config.ScrapItems = { --change to whatever you like to recieve when scrapping
    'lockpick',
    'electronickit',
    'tunerlaptop',
    'nitrous',
    'metalscrap',
}
Config.NumberOfScrapItems = 4 -- amount of different items to recieve 
Config.ScrapItemAmount = 2 --amount of each item you recieve
Config.GiveScrapMoney = true -- if false will only give items when scrapping 
Config.ScrapMoneyLow = 20
Config.ScrapMoneyMax = 40

--//VEHICLES//--   --add as many car models as you want to each 3 Tiers
Config.VehicleTierA = { 
    BoostVehicles = {
        {model = 'panto', name = "Panto"},
        {model = 'club', name = "Club"},
        {model = 'gauntlet', name = "Gauntlet"},
        {model = 'sentinel2', name = "Sentinel XS"},
        {model = 'sultan', name = "Sultan"},
        {model = 'vigero', name = "Vigero"},
        {model = 'schafter4', name = "Schafter LBW"},
        {model = 'fugitive', name = "Fugitive"},
    }, 
}

Config.VehicleTierB = {  
    BoostVehicles = {
        {model = 'jugular', name = "Jugular"},
        {model = 'rapidgt', name = "Rapid GT"},
        {model = 'massacro', name = "Massacro"},
        {model = 'jester', name = "Jester"},
        {model = 'coquette', name = "Coquette"},
        {model = 'banshee', name = "Banshee"},
    }, 
}

Config.VehicleTierC = {  
    BoostVehicles = {
        {model = 'tigon', name = "Tigon"},
        {model = 'turismor', name = "Turismo R"},
        {model = 'turismo2', name = "Turismo Classic"},
        {model = 'thrax', name = "Thrax"},
        {model = 'tezeract', name = "Tezeract"},
        {model = 'emerus', name = "Emerus"},
    }, 
}

--//LOCATIONS//--
Config.CarHeistLocations = {
    ["Deliver"] = vector4(-430.1, -2667.63, 5.64, 133.46), --location to drop cars off for money
    ["Scrap"] = vector4(946.2, -1697.89, 29.66, 86.49), --location to scrap car for parts instead
    CarSpawn = {  --add as many locations as you want
        {name = "Kortz Center Parking", coords = vector4(-2347.76, 283.01, 168.79, 294.12)},
        {name = "Golf Club Parking", coords = vector4(-1405.61, 77.69, 52.64, 234.95)},
        {name = "La Spada Parking", coords = vector4(-1034.38, -1331.71, 5.08, 72.78)},
        {name = "Mirror Park Digital Den", coords = vector4(1129.78, -484.97, 65.26, 256.65)},
        {name = "Integrity Way Bus Station", coords = vector4(393.5, -660.47, 28.16, 269.08)},
        {name = "LifeInvader Building", coords = vector4(-1053.3, -222.55, 37.7, 67.2)},
        {name = "Casino Parking", coords = vector4(933.5, -96.13, 78.4, 41.55)},
        {name = "The Motor Hotel", coords = vector4(1120.34, 2647.24, 37.63, 0.82)},
        {name = "Yellow Jack Inn", coords = vector4(1999.53, 3081.5, 46.71, 143.7)},
        {name = "Sandy Shores Gas Station", coords = vector4(1979.38, 3784.78, 31.82, 28.73)},
        {name = "Vineyard", coords = vector4(-1906.35, 2004.55, 141.47, 271.08)},
        {name = "Paleto Skylift Parking", coords = vector4(-755.86, 5548.87, 33.12, 178.38)},
        {name = "Paleto Gas Station", coords = vector4(187.98, 6632.77, 31.19, 182.01)},
        {name = "Grapeseed Gas Station", coords = vector4(1704.33, 4947.59, 42.17, 58.25)},
        {name = "YouTool Parking", coords = vector4(2795.52, 3486.15, 54.69, 63.82)},
    },
}