fx_version 'cerulean'

game 'gta5'

author 'scarfoxed'

description 'miniheists using targeting with hacks and npcs'

version '2.2.0'

client_scripts {
	'client/main.lua',
	'client/humane.lua',
	'client/merryweather.lua',
	'client/carboost.lua'
}

server_scripts {
	'server/main.lua'
}

shared_scripts{
    'config.lua',
	'@ox_lib/init.lua',
}

lua54 'yes'
