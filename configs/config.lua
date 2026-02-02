Config = {}
--███████╗██████╗  █████╗ ███╗   ███╗███████╗██╗    ██╗ ██████╗ ██████╗ ██╗  ██╗
--██╔════╝██╔══██╗██╔══██╗████╗ ████║██╔════╝██║    ██║██╔═══██╗██╔══██╗██║ ██╔╝
--█████╗  ██████╔╝███████║██╔████╔██║█████╗  ██║ █╗ ██║██║   ██║██████╔╝█████╔╝ 
--██╔══╝  ██╔══██╗██╔══██║██║╚██╔╝██║██╔══╝  ██║███╗██║██║   ██║██╔══██╗██╔═██╗ 
--██║     ██║  ██║██║  ██║██║ ╚═╝ ██║███████╗╚███╔███╔╝╚██████╔╝██║  ██║██║  ██╗
--╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝ ╚══╝╚══╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝


Config.Database = 'oxmysql' --[ 'mysql' / 'ghmattimysql' / 'oxmysql' ] Choose your sql database script.
Config.Framework = 'none' ---[ 'esx' / 'qbcore' / 'vrp' / 'none' / 'other' ] Choose your framework.
Config.Language = 'EN' --[ 'EN' / 'BG' / 'CZ' / 'DE' / 'ES' / 'FI' / 'FR' / 'NL' / 'SE' / 'SK' ] You can add your own locales to the Locales.lua. But make sure to change the Config.Language to match it.

Config.FrameworkTriggers = { --You can change the esx/qbcore events (IF NEEDED).
    main = 'esx:getSharedObject',   --ESX = 'esx:getSharedObject'   QBCORE = 'QBCore:GetObject'
    load = 'esx:playerLoaded',      --ESX = 'esx:playerLoaded'      QBCORE = 'QBCore:Client:OnPlayerLoaded'
    job = 'esx:setJob',             --ESX = 'esx:setJob'            QBCORE = 'QBCore:Client:OnJobUpdate'
	resource_name = 'es_extended'   --ESX = 'es_extended'           QBCORE = 'qb-core'
}

Config.NotificationType = { --[ 'esx' / 'qbcore' / 'mythic_old' / 'mythic_new' / 'chat' / 'other' ] Choose your notification script.
    server = 'other',
    client = 'other' 
}


--██╗███╗   ███╗██████╗  ██████╗ ██████╗ ████████╗ █████╗ ███╗   ██╗████████╗
--██║████╗ ████║██╔══██╗██╔═══██╗██╔══██╗╚══██╔══╝██╔══██╗████╗  ██║╚══██╔══╝
--██║██╔████╔██║██████╔╝██║   ██║██████╔╝   ██║   ███████║██╔██╗ ██║   ██║   
--██║██║╚██╔╝██║██╔═══╝ ██║   ██║██╔══██╗   ██║   ██╔══██║██║╚██╗██║   ██║   
--██║██║ ╚═╝ ██║██║     ╚██████╔╝██║  ██║   ██║   ██║  ██║██║ ╚████║   ██║   
--╚═╝╚═╝     ╚═╝╚═╝      ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝


Config.SpawnOptions = {
	last = false, --Do you want to allow players to spawn in their last saved position 	(this requires either esx, qbcore or you can edit the code and use your own framework).
	job = false, --Do you want to allow players with defined jobs to spawn at their workplace 	(this requires either esx, qbcore or you can edit the code and use your own framework).
	personal = false, --Do you want to allow a player to set and choose their own personal spawn location 	(this requires either esx, qbcore or you can edit the code and use your own framework).
	personal_command = 'personalspawn' --Set the name of the command to show/set/delete your personal spawn location.
}


--███╗   ███╗ █████╗ ██╗███╗   ██╗
--████╗ ████║██╔══██╗██║████╗  ██║
--██╔████╔██║███████║██║██╔██╗ ██║
--██║╚██╔╝██║██╔══██║██║██║╚██╗██║
--██║ ╚═╝ ██║██║  ██║██║██║ ╚████║
--╚═╝     ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝


Config.EnableTestCommand = true --Set to true to enable the test command '/openspawnselect'.
Config.BuggedSpawnCoords = {x = 314.86, y = -213.28, z = 54.09, h = 44.56} --If there is an error or the database coords are nil, this will be a backup spawn location.
Config.DayHours = {[1] = 6, [2] = 22} --If the game time is between 6am (6) to 10pm (22) then dark mode will be enabled, else lightmode will be enabled (using 24 hour clock).

Config.JobSpawnsCoords = { --If Config.Job_Spawns is enabled then you can customise which jobs are eligable and where they spawn.
  	['ambulance'] 		= {x = 296.09, y = -601.04, z = 43.35, h = 93.08, 		name = 'LSFD'},
    ['mechanic'] 		= {x = 949.64, y = -986.29, z = 39.83, h = 110.17,  	name = 'Mechanic'},
    ['police'] 			= {x = 435.48, y = -975.08, z = 30.72, h = 83.66,  		name = 'Police'},
    ['cardealer'] 		= {x = -815.98, y = -194.89, z = 37.52, h = 115.08,  	name = 'Car Dealer'}, 
    ['taxi'] 			= {x = 907.01, y = -164.23, z = 74.12, h = 162.66,  	name = 'Taxi'},
}

Config.MainSpawns = { --The names in the mapdata.js must match with the name here to get the correct coordinates.
  	['The Kortz Center'] 					= {x = -2291.47, y = 366.14, z = 174.6, h = 27.47},
  	['Maze Bank Arena'] 					= {x = -249.82, y = -2031.23, z = 29.95, h = 230.62},
  	['Sandy Shores Sheriff\'s Station'] 	= {x = 1877.17, y = 3706.46, z = 33.19, h = 169.16},
  	['Bolingbroke Penitentiary'] 			= {x = 1852.88, y = 2581.95, z = 45.67, h = 283.87},
  	['Luxury Autos'] 						= {x = -815.98, y = -194.89, z = 37.52, h = 115.08},
  	['Vinewood Motel'] 						= {x = 436.25, y = 215.84, z = 103.17, h = 338.43},
  	['Mission Row Police Department'] 		= {x = 435.48, y = -975.08, z = 30.72, h = 83.66},
  	['Paleto Bay Troopers Office'] 			= {x = -448.05, y = 5986.79, z = 31.49, h = 20.64},
  	['Paleto Garage'] 						= {x = 101.82, y = 6617.12, z = 32.47, h = 239.29},
  	['Grapeseed Store'] 					= {x = 1692.32, y = 4917.21, z = 42.08, h = 59.45},
  	['Airport - LSIA'] 						= {x = -1036.96, y = -2736.84, z = 20.17, h = 327.0},
  	['Del Perro Pier'] 						= {x = -1691.58, y = -1099.54, z = 13.15, h = 47.01},
  	['Eastern Motel'] 						= {x = 317.9, y = 2623.21, z = 44.47, h = 292.39},
  	['Stab City'] 							= {x = 79.08, y = 3708.11, z = 41.08, h = 53.36},
  	['Sandy Shores Airport'] 				= {x = 1759.0, y = 3298.66, z = 41.74, h = 143.01},
  	['Vinewood Casino'] 					= {x = 926.66, y = 45.63, z = 80.9, h = 57.57},
  	['Grove Street Garage'] 				= {x = -78.47, y = -1832.54, z = 27.03, h = 320.42},
  	['Mirror Park Garage'] 					= {x = 1033.57, y = -768.57, z = 58.0, h = 49.98},
}


-- ██████╗ ████████╗██╗  ██╗███████╗██████╗ 
--██╔═══██╗╚══██╔══╝██║  ██║██╔════╝██╔══██╗
--██║   ██║   ██║   ███████║█████╗  ██████╔╝
--██║   ██║   ██║   ██╔══██║██╔══╝  ██╔══██╗
--╚██████╔╝   ██║   ██║  ██║███████╗██║  ██║
-- ╚═════╝    ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝


function L(l) return Locales[Config.Language][l] end
if Config.Framework == 'vrp' or Config.Framework == 'none' then --if you use vrp or no framework we will disable last position, job spawns and personal spawns.
	Config.SpawnOptions.last = false
	Config.SpawnOptions.job = false
	Config.SpawnOptions.personal = false
end

