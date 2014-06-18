# NodelicAPI v0.1.1

vs = '0.1.1'

hs = require 'http-sync'
en = require 'utf8'

rq = (path, data) ->
    try
        r = JSON.parse(hs.request
            method: 'POST'
            headers:
                'User-Agent': "Nodelic/#{vs}"
            body: en.encode JSON.stringify data
            protocol: 'http'
            host: 'chatadelic.net'
            port: 80
            path: path
        .end().body.toString())
        return r
    catch error
        console.log "Error in .rq(#{path}): "
        console.log error
        return {error: 1}

exports.api =
    path: 
        login:  '/login/chatLogin'
        action: '/server/ajax/action'
        listen: '/server/ajax/listen'
    login: (name, pass, chat) ->
        rq @path.login,
            act:        'login'
            chat:       chat
            login:      name
            password:   pass
    logout: (skey, chat) ->
        rq @path.action,
            act:    'logout'
            chat:   chat
            _:      skey
    msg: (skey, chat, msg) ->
        rq @path.action,
            act:    'msg'
            chat:   chat
            _:      skey
            msg:    msg
    listen: (skey, chat) ->
        rq @path.listen,
            act:    'listen'
            chat:   chat
            _:      skey
    status: (skey, chat, status) ->
        rq @path.action,
            act:    'setStatus'
            chat:   chat
            _:      skey
            status: status
    color: (skey, chat, color) ->
        rq @path.action,
            act:    'saveChatSettings'
            chat:   chat
            _:      skey
            settings:
                textColor: color
    kick: (skey, chat, who, why) ->
        rq @path.action,
            act:    'moder'
            chat:   chat
            _:      skey
            name:   who
            why:    why
            moderCommand: 'kick'
    ban: (skey, chat, who, why, time, clear) ->
        rq @path.action,
            act:    'moder'
            chat:   chat
            _:      skey
            name:   who
            why:    why
            time:   time
            ban:    true
            deleteMessages: clear
            moderCommand:   'ban'
    warn: (skey, chat, who, why) ->
        rq @path.action,
            act:    'moder'
            chat:   chat
            _:      skey
            name:   who
            why:    why
            moderCommand: 'warn'