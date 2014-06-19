api = require('./api').api # Nodelic API // github.com/dacxie/nodelic
fs  = require 'fs'

# Bot V0.6.0 - Dacx

# Usage: node bot <username> <password> <chat> <owner>

# --------------- Bot funtions block --------------- #

String::contains = () ->
    String::indexOf.apply(this, arguments) isnt -1
    
    
String::starts = () ->
    String::indexOf.apply(this, arguments) is 0


include = (file) ->
    try
        eval fs.readFileSync "./bin/#{file}.js", 'utf-8'
        console.log "[Info] Included #{file}"
    catch error
        console.log "[Fatal] Error in #{file}"
        process.exit 1
    return


botLogin = ->
    response = api.login botData.username, botData.password, botData.chat
    if response.status isnt 'success'
        console.log '[Fatal] Cannot log in'
        process.exit 1
    else
        botData.loginKey    = response._
        botData.isModerator = (response.moder? || response.admin?)
        console.log "[Info] Logged in, isModerator: #{botData.isModerator}"
    return


botLoop = ->
    response = api.listen botData.loginKey, botData.chat
    for event in response.m
        if event.status is 'mustlogin' || event.status is 'notlogged'
            botLogin()
        else
            botModules.notifyHandlers event
    botLoop()
    return
    
    
# ----------------- Bot data block ----------------- #

botData =
    ownerName:   process.argv[5]
    username:    process.argv[2]
    password:    process.argv[3]
    chat:        process.argv[4]
    loginKey:    null
    isModerator: null

# ------------ Bot initialization block ------------ #

include 'botApi'
include 'parseEvents'
include 'modules'
botModules.loadModule 'modcontrol'
botLogin()
botLoop()