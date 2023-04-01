fx_version 'adamant'

game 'gta5'

description 'CRP Jobs v2'
lua54 'yes'
version '1.8.5'


shared_scripts {
	'@es_extended/imports.lua',
	'config.lua',
	'jobs/*.lua',
	'client/functions.lua',
}
    
server_scripts {
	'server/main.lua',
}

client_scripts {
	'@PolyZone/client.lua',
	'@PolyZone/CircleZone.lua',

	'client/main.lua',
}

dependency 'es_extended'
