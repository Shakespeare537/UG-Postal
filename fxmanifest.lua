local postalFile = 'postalcodes.json'

fx_version 'cerulean'
game 'gta5'
lua54 "yes"

author 'Shakespeare'
description 'UG Postal Command'
version '1.0'

client_scripts {
    'shared/config.lua',
    'client/main.lua',
}

--server_scripts {
--    'shared/config.lua',
--    'server/main.lua'
--}

file(postalFile)
postal_file(postalFile)