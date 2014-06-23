request = require 'request'

module.exports.init = ->
    commands = 
        joke:      setCommand([/^(по)?шути|^(расскажи )?шутку/i], [], 'user')
        setServer: setCommand([/^бери шутки из ([а-я]+) сервера/i], [{name: 'server', regex: 0, match: 1}], 'admin')
    servers =
        own: 'http://sovngarde.1.vg/bot/joke.php'
        lc:  'http://pavel.forum.lc/bot/petrosyan.php'
    server = 'own'
    joke = (name) ->
        request.get
            url: servers[server]
        , (error, response, body) ->
            bot.cmd.say name + ', ' + body
            return
        return
    @registerHandler 'jokeCommand', 'talk', true,
    (event) ->
        testCommand commands.joke, event, yes
    ,
    (event) ->
        joke event.from
        return
    @registerHandler 'setServerCommand', 'talk', true,
    (event) ->
        testCommand commands.setServer, event, yes
    ,
    (event) ->
        switch parseCommand(commands.setServer, 0, event, yes).server
            when 'своего'
                server = 'own'
                bot.cmd.say 'Есть, мэм'
            when 'лцшного'
                server = 'lc'
                bot.cmd.say 'Есть, мэм'
            else
                bot.cmd.say 'Я не знаю такого сервера'
        return
    return