fx_version 'cerulean'
game 'gta5'

author 'TechRiseDev'
description 'Location de karts avec PNJ, ox_target et despawn automatique'

shared_script '@ox_lib/init.lua'

client_script 'client.lua'
server_script 'server.lua'

dependencies {
    'ox_lib',
    'ox_target',
    'es_extended'
}
