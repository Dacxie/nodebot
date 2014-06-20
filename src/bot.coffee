api = require('./api').api # Nodelic API // github.com/dacxie/nodelic

# Bot V0.7.2 - Dacx

# Usage: node bot <username> <password> <chat> <owner>

# --------------- Bot funtions block --------------- #

@botLogin = ->
    response = api.login botData.username, botData.password, botData.chat
    if response.status isnt 'success'
        console.log '[Fatal] Cannot log in'
        process.exit 1
    else
        botData.loginKey    = response._
        botData.isModerator = (response.moder? || response.admin?)
        console.log "[Info] Logged in, isModerator: #{botData.isModerator}"
    return

needReload = true
@botLoop = ->
    response = api.listen botData.loginKey, botData.chat, needReload
    try
        for event in response.m
            if event.status is 'mustlogin' || event.status is 'notlogged'
                botLogin()
            else
                botModules.notifyHandlers event, needReload
    catch error
        console.log error
        console.log '[Error] In bot loop'
    needReload = false if needReload
    botLoop()
    return
    
    
# ----------------- Bot data block ----------------- #

@botData =
    ownerName:   process.argv[5]
    username:    process.argv[2]
    password:    process.argv[3]
    chat:        process.argv[4]
    loginKey:    null
    isModerator: null