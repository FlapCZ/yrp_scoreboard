------------------------------------------------------------
--------------------- yrp_scoreboard -----------------------
------------------------------------------------------------
--------------------- Created by Flap ----------------------
------------------------------------------------------------
----------------- YourRolePlay Development -----------------
----------- Thank you for using this scoreboard ------------
----- Regular updates and lots of interesting scripts ------
--------- discord -> https://discord.gg/hqZEXc8FSE ---------
------------------------------------------------------------
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'YourRolePlay Development Scoreboard'
author 'YourRolePlay Development // discord -> https://discord.gg/uSv9sWwhE9'
version '0.5'

client_scripts {
	'config/config.lua',
	'client/main.lua'
}

server_scripts {
	'config/config.lua',
	'server/main.lua'
}

ui_page 'html/scoreboard.html'

files {
	'html/scoreboard.html',
	'html/style.css',
	'html/listener.js'
}