fs = require 'fs'

include = (file) ->
    try
        eval fs.readFileSync "./bin/#{file}.js", 'utf-8'
        console.log "[Info] Included #{file}"
    catch error
        console.log "[Fatal] Error in #{file}"
        process.exit 1
    return

include 'bot'
include 'essentials'
include 'modules'
botModules.loadModule 'modcontrol'
botModules.loadModule 'moduserlist'
botLogin()
botLoop()