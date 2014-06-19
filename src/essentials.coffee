# This file is included in bot.coffee

api = require('./api').api

String::contains = () ->
    String::indexOf.apply(this, arguments) isnt -1
    
String::starts = () ->
    String::indexOf.apply(this, arguments) is 0

@stripTags = (string) ->
    string.replace(/<(.|\n)*?>/g, '')

@parse =
    msg:  (event, toMe) ->
        data =
            text: event.text.replace((if toMe then new RegExp("#{botData.username}, ?", 'i') else ''), '')
            from: event.from
            role: if event.fl? then event.fl else 'user'
    user: (event) ->
        data =
            type: event.event
            name:  event.user.name
            id:    event.user.regId

@botCommand =
    say: (message) ->
        api.msg botData.loginKey, botData.chat, message
        return
    login: () ->
        api.login botData.username, botData.password, botData.chat
        return
    logout: () ->
        api.logout botData.loginKey, botData.chat
        return
    status: (status) ->
        api.status botData.loginKey, botData.chat, status
        return
    color: (color) ->
        api.color botData.loginKey, botData.chat, color
        return
    kick: (who, why) ->
        api.kick botData.loginKey, botData.chat, who, why
        return
    ban: (who, why, length, clear) ->
        api.ban botData.loginKey, botData.chat, who, why, length, clear
        return
    warn: (who, why) ->
        api.warn botData.loginKey, botData.chat, who, why
        return