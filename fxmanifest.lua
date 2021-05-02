fx_version 'adamant'
game 'gta5'

name 'master_banking'
author 'MasterkinG32#9999'
description 'MasterkinG32 Bank System!'
version '1.0.0'

ui_page 'client/html/UI.html'

client_scripts {
	'client/client.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server.lua',
}

files {
    'client/html/UI.html',
    'client/html/style.css',
	'client/html/img/phone.png',
	'client/html/img/fingerprint.png',
}

dependencies {
	'es_extended'
}
