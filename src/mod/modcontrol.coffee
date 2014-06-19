module.exports.init = ->
    @registerEventHandler false, 'loadModule', 'msgToMe',
    (event) ->
        msg = parse.msg event, yes
        (/module load (mod[a-z0-9]+)/.test msg.text) && msg.role is 'admin' && !msg.old
    ,
    (event) ->
        name = parse.msg(event, yes).text.match(/module load (mod[a-z0-9]+)/)[1]
        botCommand.say 'Status: ' + botModules.loadModule name
        return
        
    @registerEventHandler false, 'unloadModule', 'msgToMe',
    (event) ->
        msg = parse.msg event, yes
        (/module unload (mod[a-z0-9]+)/.test msg.text) && msg.role is 'admin' && !msg.old
    ,
    (event) ->
        name = parse.msg(event, yes).text.match(/module unload (mod[a-z0-9]+)/)[1]
        botCommand.say 'Status: ' + botModules.unloadModule name
        return
    
    @registerEventHandler false, 'listModule', 'msgToMe',
    (event) ->
        msg = parse.msg event, yes
        (/module list/.test msg.text) && msg.role is 'admin' && !msg.old
    ,
    (event) ->
        list = ''
        for name, module of botModules.modules
            if list isnt ''
                list += ', '
            list += "#{name}"
        list = 'Modules: ' + list
        if list.length > 300
            loop
                botCommand.say list
                list = list.substr 300
        botCommand.say list
        return