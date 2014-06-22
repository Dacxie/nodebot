# NodelicBot v0.1.0-Sync

@api = require('./api').api

@bot =
    needsReload: yes
    data:
        key:  null
        name: process.argv[2]
        pass: process.argv[3]
        chat: process.argv[4]
        role: null
    login: (callback) ->
        api.login bot.data.name, bot.data.pass, bot.data.chat, (error, data) ->
            if data.status is 'success'
                bot.data.role = if (data.moder? || data.admin?) then 'moder' else 'user'
                bot.data.key  = data._
                console.log "[Info] Logged in. Role: #{bot.data.role}"
                callback null, 1
            else
                console.log '[Error] Login rejected.'
                process.exit 1
            return
        return
    handle: (event) ->
        if event.status is 'notlogged' || event.status is 'mustlogin'
            bot.data.key = null
            bot.login bot.action
            return
        bot.modules.notify event, bot.needsReload
        return
    action: ->
        if bot.data.key is null
            return
        api.listen bot.data.key, bot.data.chat, bot.needsReload, (error, data) ->
            try
                for event in data.m
                    bot.handle event
            catch exception
                console.log '[Error] Catched in bot loop'
                console.log exception
            bot.needsReload = no if bot.needsReload
            bot.action()