fx_version 'bodacious'
game 'gta5'

name 'gp_dutyBlips'
description 'Color Blips depending on onduty members'

version '1.0.0'

author 'gpScript / Gamingpions <store@gp-resources.net>'
lua54 'yes'

shared_scripts {
  '@qb-core/shared/locale.lua',
  'config.lua',
}

client_scripts {
  'client/*.lua',
}

server_scripts {
  'server/*.lua',
}

escrow_ignore {
  'config.lua',
  'client/*.lua',
}
