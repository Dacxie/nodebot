nd = require('./api').api # Nodelic API // github.com/dacxie/nodelic

# Bot V0.1.3 - Dacx

# Usage: node bot <username> <password> <chat>

botData =
    owner:       process.argv[5]
    username:    process.argv[2]
    password:    process.argv[3]
    chat:        process.argv[4]
    loginKey:    null
    isModerator: null
    
chatCommands = []

addCommand = (condition, onCall) ->
    chatCommands.push
        cond: condition
        call: onCall
        
addCommand(
    (messageData) ->
        (messageData.text.indexOf('поговори с ') is 0)
    , 
    (messageData) ->
        nd.msg botData.skey, botData.chat, "#{messageData.text.substr 11}, Мне нечего сказать."
        return
)
addCommand(
    (messageData) ->
        (messageData.text.indexOf('someadminstuff') is 0 && messageData.author.right is 'admin')
    ,
    (messageData) ->
        nd.msg botData.skey, botData.chat, 'admin'
        return
)
    
botLogin = ->
    loginResponse = nd.login botData.username, botData.password, botData.chat
    if loginResponse.status isnt 'success'
        console.log '[Fatal] Cannot login to chat.'
        process.exit 1
    botData.skey = loginResponse._
    botData.isModerator = (loginResponse.moder? || loginResponse.admin?)
    console.log "Logged in, moderator = #{botData.isModerator}"
botLogin()

processMessage = (message) ->
    messageData =
        text: message.text.replace(bi.name + ',', '')
        author:
            name:  message.from
            right: if !message.fl? then 'user' else message.fl
    messageData.text = messageData.text.substr(1) if messageData.text[0] is ' '
    for command in chatCommands
        if command.cond messageData
            command.call messageData
    
onMessage = (message) ->
    if message.t is 'msg'
        if message.text.indexOf(botData.username + ',') is 0
            processMessage message
            
botLoop = ->
    listenData = nd.listen botData.skey, botData.chat
    for message in listenData.m
        if message.status is 'mustlogin'
            console.log '[Danger] Kicked out of chat. Logging in'
            botLogin()
        else
            onMessage message
    botLoop()
botLoop()