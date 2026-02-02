fx_version 'cerulean'
game 'gta5'
author 'Crow'
description 'Spawn Selector'
version '1.0.0'
lua54 'yes'

shared_scripts {
    'configs/locales.lua',
    'configs/config.lua'
}

client_scripts {
    'configs/client_customise_me.lua',
    'client/*.lua'
}

server_scripts {
    'configs/server_customise_me.lua',
    'server/*.lua'
}

ui_page {
    'html/index.html'
}

files {
    'configs/mapdata.js',
    'configs/locales_ui.js',
    'html/index.html',
    'html/css/*.css',
    'html/js/*.js',
    'html/libraries/*.js',
    'html/libraries/*.css',
    'html/images/*.png',
    'html/images/*.svg',
    'html/images/*.jpg'
}

escrow_ignore {
    'configs/config.lua',
    'configs/locales.lua',
    'configs/client_customise_me.lua',
    'configs/server_customise_me.lua',
    'configs/mapdata.js',
    'configs/locales_ui.js'
}

