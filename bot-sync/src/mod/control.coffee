module.exports.init = ->
    @registerHandler 'loadMessage', 'talk', true,
    (event) ->
        msg = parse.msg event, yes
        adminCommand msg, /^module load [a-z0-9-]+/
    ,
    (event) ->
        module = parse.msg(event, yes).text.match(/^module load ([a-z0-9-]+)/)[1]
        bot.modules.load module, (error, result) ->
            if result.error?
                bot.cmd.say 'Error: ' + result.error
                return
            if result is 1
                bot.cmd.say 'Loaded: ' + module
                return
            return
        return
    @registerHandler 'unloadMessage', 'talk', true,
    (event) ->
        msg = parse.msg event, yes
        adminCommand msg, /^module unload [a-z0-9-]+/
    ,
    (event) ->
        module = parse.msg(event, yes).text.match(/^module unload ([a-z0-9-]+)/)[1]
        bot.modules.unload module, (error, result) ->
            if result.error?
                bot.cmd.say 'Error: ' + result.error
                return
            if result is 1
                bot.cmd.say 'Unloaded: ' + module
                return
            return
        return
    @registerHandler 'reloadMessage', 'talk', true,
    (event) ->
        msg = parse.msg event, yes
        adminCommand msg, /^module reload [a-z0-9-]+/
    ,
    (event) ->
        module = parse.msg(event, yes).text.match(/^module reload ([a-z0-9-]+)/)[1]
        bot.modules.reload module, (error, result) ->
            if result.error?
                bot.cmd.say 'Error: ' + result.error
                return
            if result is 1
                bot.cmd.say 'Reloaded: ' + module
                return
            return
        return
    @registerHandler 'listMessage', 'talk', true,
    (event) ->
        msg = parse.msg event, yes
        adminCommand msg, /module list/
    ,
    (event) ->
        list = ''
        for name, module of bot.modules.loaded
            if list isnt ''
                list += ', '
            list += name
        list = 'Loaded: ' + list
        if list.length > 300
            loop
                bot.cmd.say list
                list = list.substr 300
                break if list.length <= 300
        bot.cmd.say list
        return