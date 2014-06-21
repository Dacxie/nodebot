fs = require 'fs'

include = (file) ->
    try
        eval fs.readFileSync "./bin/#{file}.js", 'utf-8'
        console.log "[Info] Included #{file}"
    catch error
        console.log error
        console.log "[Error] Error in #{file}"
        process.exit 1
    return

include 'bot'
include 'essentials'
include 'modules'
bot.modules.load 'control', (error, data) ->
bot.modules.load 'userlist', (error, data) ->
    bot.login (error, data) ->
        bot.action()