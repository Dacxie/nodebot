api = require('./api').api # Nodelic API // github.com/dacxie/nodelic
fs  = require 'fs'

# Bot V0.4.0 - Dacx

# Usage: node bot <username> <password> <chat>

# --------------- Bot funtions block --------------- #

constructMessageData = (event) ->
    text = event.text.replace botData.username + ',', ''
    text = text.substr 1 if text[0] is ' '
    messageData =
        text: text
        author:
            name:  event.from
            right: if event.fl? then event.fl else 'user'


botLogin = ->
    response = api.login botData.username, botData.password, botData.chat
    if response.status isnt 'success'
        console.log '[Fatal] Cannot log in'
        process.exit 1
    else
        botData.loginKey    = response._
        botData.isModerator = (response.moder? || response.admin?)
        console.log '[Info] Logged in, isModerator: #{botData.isModerator}'
    return
        

botSay = (message) ->
    response = api.msg botData.loginKey, botData.chat, message
    if response.result isnt 'ACCEPTED' && response.result isnt 'HANDLED'
        console.log '[Warning] Bot\'s message rejected'
    return


botLoop = ->
    response = api.listen botData.loginKey, botData.chat
    for event in response.m
        if event.status is 'mustlogin' || event.status is 'notlogged'
            botLogin()
        else
            processChatEvent event
    botLoop()
    return
    
    
botReact = (event) ->
    messageData = constructMessageData event
    for event in botEvents
        if event.condition messageData
            event.perform messageData
    return
    

addBotEvent = (condition, perform) ->
    botEvents.push
        condition: condition
        perform:   perform
    
    
reloadBotEvents = ->
    fileData = fs.readFileSync './bin/events.js', 'utf8'
    eval fileData
    
    
processChatEvent = (event) ->
    if event.t is 'msg'
        if event.text.indexOf(botData.username + ',') is 0
            botReact event
    return
    
# ----------------- Bot data block ----------------- #

botData =
    ownerName:   process.argv[5]
    username:    process.argv[2]
    password:    process.argv[3]
    chat:        process.argv[4]
    loginKey:    null
    isModerator: null
    
botEvents = []

# ------------ Bot initialization block ------------ #

reloadBotEvents()
botLogin()
botLoop()