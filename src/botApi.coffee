# This file is included in bot.coffee

@botSay = (message) ->
    response = api.msg botData.loginKey, botData.chat, message
    if response.result isnt 'ACCEPTED' && response.result isnt 'HANDLED'
        console.log '[Warning] Bot\'s message rejected'
    return
@botKick = (who, why) ->
    api.kick botData.loginKey, botData.chat, who, why
    return