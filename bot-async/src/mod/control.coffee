module.exports.init = ->
    commands =
        load:   setCommand([/^module load ([a-z0-9-]+)/], [{name: 'name', regex: 0, match: 1}], 'admin')
        unload: setCommand([/^module unload ([a-z0-9-]+)/], [{name: 'name', regex: 0, match: 1}], 'admin')
        reload: setCommand([/^module reload ([a-z0-9-]+)/], [{name: 'name', regex: 0, match: 1}], 'admin')
        list:   setCommand([/^module list/], [], 'admin')
    @registerHandler 'loadMessage', 'talk', yes,
    (event) ->
        testCommand commands.load, event, yes
    ,
    (event) ->
        module = parseCommand(commands.load, 0, event, yes).name
        bot.modules.load module, (error, result) ->
            if result.error?
                bot.cmd.say 'Ошибка: ' + result.error
                return
            if result is 1
                bot.cmd.say 'Загружено: ' + module
                return
            return
        return
    @registerHandler 'unloadMessage', 'talk', yes,
    (event) ->
        testCommand commands.unload, event, yes
    ,
    (event) ->
        module = parseCommand(commands.unload, 0, event, yes).name
        bot.modules.unload module, (error, result) ->
            if result.error?
                bot.cmd.say 'Ошибка: ' + result.error
                return
            if result is 1
                bot.cmd.say 'Выгружено: ' + module
                return
            return
        return
    @registerHandler 'reloadMessage', 'talk', yes,
    (event) ->
        testCommand commands.reload, event, yes
    ,
    (event) ->
        module = parseCommand(commands.reload, 0, event, yes).name
        bot.modules.reload module, (error, result) ->
            if result.error?
                bot.cmd.say 'Ошибка: ' + result.error
                return
            if result is 1
                bot.cmd.say 'Перезагружено: ' + module
                return
            return
        return
    @registerHandler 'listMessage', 'talk', yes,
    (event) ->
        testCommand commands.list, event, yes
    ,
    (event) ->
        list = ''
        for name, module of bot.modules.loaded
            if list isnt ''
                list += ', '
            list += name
        list = 'Загружено: ' + list
        if list.length > 300
            loop
                bot.cmd.say list
                list = list.substr 300
                break if list.length <= 300
        bot.cmd.say list
        return