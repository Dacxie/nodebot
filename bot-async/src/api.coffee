# NodelicAPI v0.1.0-Sync

request = require 'request'

post = (url, data, callback) ->
    request.post
        uri: url
        body: JSON.stringify data
    , (error, response, body) ->
        try
            callback null, JSON.parse body
        catch error
            console.log '[Error] Network error'
            console.log '[Error] ' + error
            callback null, 1
        return
    return

url  =
    login:  'http://chatadelic.net/login/chatLogin'
    action: 'http://chatadelic.net/server/ajax/action'
    listen: 'http://chatadelic.net/server/ajax/listen'
    
exports.api =
    login: (name, pass, chat, callback) ->
        post url.login,
            act: 'login'
            chat: chat
            login: name
            password: pass
        , callback
        return
    logout: (skey, chat, callback) ->
        post url.action,
            act: 'logout'
            chat: chat
            _: skey
        , callback
        return
    msg: (skey, chat, msg, callback) ->
        post url.action,
            act: 'msg'
            chat: chat
            _: skey
            msg: msg
        , callback
        return
    listen: (skey, chat, reload, callback) ->
        post url.listen,
            act: 'listen'
            chat: chat
            _: skey
            reload: reload
        , callback
        return
    status: (skey, chat, status, callback) ->
        post url.action,
            act: 'setStatus'
            chat: chat
            _: skey
            status: status
        , callback
        return
    color: (skey, chat, color, callback) ->
        post url.action,
            act: 'saveChatSettings'
            chat: chat
            _: skey
            settings:
                textColor: color
        , callback
        return
    kick: (skey, chat, who, why, callback) ->
        post url.action,
            act: 'moder'
            chat: chat
            _: skey
            name: who
            why: why
            moderCommand: 'kick'
        , callback
        return
    ban: (skey, chat, who, why, time, clear, callback) ->
        post url.action,
            act: 'moder'
            chat: chat
            _: skey
            name: who
            why: why
            time: time
            ban: true
            deleteMessages: clear
            moderCommand: 'ban'
        , callback
        return
    warn: (skey, chat, who, why, callback) ->
        post url.action,
            act: 'moder'
            chat: chat
            _: skey
            name: who
            why: why
            moderCommand: 'warn'
        , callback
        return
    delmsg: (skey, chat, id, callback) ->
        api.msg skey, chat, '/delmsg ' + id, callback
        return