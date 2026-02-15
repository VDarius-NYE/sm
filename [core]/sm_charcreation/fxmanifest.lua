fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'SilverMilitary Development'
description 'SilverMilitary Character Creation'
version '1.0.0'

shared_scripts {
    '@sm_core/shared/main.lua',
    '@sm_core/shared/config.lua',
    '@sm_core/shared/functions.lua',
    'config.lua'
}

server_scripts {
    'server/main.lua'
}

client_scripts {
    'client/main.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}

dependencies {
    'sm_core'
}