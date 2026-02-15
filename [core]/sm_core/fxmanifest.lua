fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'SilverMilitary Development'
description 'SilverMilitary Core Framework'
version '1.0.0'

shared_scripts {
    'shared/main.lua',
    'shared/config.lua',
    'shared/functions.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'config.lua',
    'server/main.lua',
    'server/player.lua',
    'server/functions.lua',
    'server/callbacks.lua'
}

client_scripts {
    'config.lua',
    'client/main.lua',
    'client/functions.lua',
    'client/callbacks.lua'
}

server_exports {
    'GetPlayer',
    'GetPlayers',
    'SetSkin',
    'GetSkin',
    'SetCharacterData',
    'SavePlayer',
    'RegisterServerCallback'
}

client_exports {
    'GetPlayerData',
    'TriggerServerCallback'
}

dependencies {
    'oxmysql'
}