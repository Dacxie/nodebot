# NodelicBot v0.4.0-ASync

@api = require('./api').api

@bot =
    needsReload: yes
    data:
        key:  null
        name: process.argv[2]
        pass: process.argv[3]
        chat: process.argv[4]
        role: null
        owner: process.argv[5]
        logged: no
    login: (callback) ->
        if bot.data.key isnt null
            api.relogin bot.data.name, bot.data.chat, bot.data.key, bot.data.pass, (error, data) ->
                if data.status is 'success'
                    bot.data.role = if (data.moder? || data.admin?) then 'moder' else 'user'
                    bot.data.logged = yes
                    console.log "[Info] Logged in. Role: #{bot.data.role}"
                    callback null, 1
                else
                    console.log '[Error] Login rejected.'
                    process.exit 1
                return
        else
            api.login bot.data.name, bot.data.pass, bot.data.chat, (error, data) ->
                if data.status is 'success'
                    bot.data.role = if (data.moder? || data.admin?) then 'moder' else 'user'
                    bot.data.key  = data._
                    bot.data.logged = yes
                    console.log "[Info] Logged in. Role: #{bot.data.role}"
                    callback null, 1
                else
                    console.log '[Error] Login rejected.'
                    process.exit 1
                return
        return
    handle: (event) ->
        if event.status is 'mustlogin'
            bot.data.key = null
            bot.data.logged = no
            console.log '[Warning] Logged out, cannot see messages'
            #bot.login bot.action
            return
        if event.status is 'notlogged'
            console.log '[Warning] Logged out, can see messages' if bot.data.logged
            bot.data.logged = no
        bot.data.logged = yes if !event.status is 'notlogged' && !event.status is 'mustlogin'
        bot.modules.notify event, bot.needsReload
        return
    action: ->
        api.listen bot.data.key, bot.data.chat, bot.needsReload, (error, data) ->
            try
                for event in data.m
                    bot.handle event
                delete data.m
            catch exception
                console.log '[Error] Catched in bot loop'
                console.log exception
            bot.needsReload = no if bot.needsReload
            if bot.data.key is null
                return
            bot.action()