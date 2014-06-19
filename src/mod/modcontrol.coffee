module.exports.init = ->
    @registerEventHandler false, 'loadModule', 'msgToMe',
    (event) ->
        (/module load (mod[a-z0-9]+)/.test parse.msg(event, yes).text) && parse.msg(event).role is 'admin'
    ,
    (event) ->
        name = parse.msg(event, yes).text.match(/module load (mod[a-z0-9]+)/)[1]
        botSay 'Status: ' + botModules.loadModule name
        return
        
    @registerEventHandler false, 'unloadModule', 'msgToMe',
    (event) ->
        (/module unload (mod[a-z0-9]+)/.test parse.msg(event, yes).text) && parse.msg(event).role is 'admin'
    ,
    (event) ->
        name = parse.msg(event, yes).text.match(/module unload (mod[a-z0-9]+)/)[1]
        botSay 'Status: ' + botModules.unloadModule name
        return
    
    @registerEventHandler false, 'listModule', 'msgToMe',
    (event) ->
        (/module list/.test parse.msg(event, yes).text) && parse.msg(event).role is 'admin'
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
                botSay list
                list = list.substr 300
        botSay list
        return