# This file is included in bot.coffee

class @BotModule
    constructor: (name, init) ->
        @name = name
        @localStorage = {}
        @eventHandlers = 
            message:    {}
            user:       {}
            msgToMe:    {}
            all:        {}
        init.apply this
    
    log: (type, data) ->
        console.log "[#{type}][#{@name}] #{data}"
    
    registerEventHandler: (mayConflict, name, event, condition, handler) ->
        if !@eventHandlers[event]?
            @log 'Error', " Invalid event type: #{event}"
            return
        if @eventHandlers[event][name]?
            @log 'Warning', "Overriding event handler #{name}"
        else
            @log 'Info', "Creating event handler #{name}"
        @eventHandlers[event][name] =
            conflict:  mayConflict
            condition: condition
            handler:   handler
        return
    
    notifyHandlers: (event, type) ->
        if !@eventHandlers[type]?
            @log 'Error', "Invalid event type: #{type}"
            return
        conflict = false
        for name, handler of @eventHandlers[type]
            if !(handler.conflict && conflict) && handler.condition event
                handler.handler event
        return
    
    handleEvent: (event) ->
        @notifyHandlers event, 'all'
        if event.t is 'msg' && event.fl isnt 'sys'
            @notifyHandlers event, 'message'
            if event.text.starts botData.username + ','
                @notifyHandlers event, 'msgToMe'
        if event.t is 'user'
            @notifyHandlers event, 'user'
        return
        

@botModules =
    modules: {}
    loadModule: (name) ->
        if !/mod([a-z0-9]+)/.test name
            console.log "[Error][Modules] #{name} is not module"
            return 'Not a module'
        if !fs.existsSync "./bin/mod/#{name}.js"
            console.log "[Error][Modules] #{name} does not exist"
            return 'Not found'
        if botModules.modules[name]?
            console.log "[Info][Modules] Reloading module #{name}"
            if require.cache[require.resolve "./mod/#{name}.js"]
                delete require.cache[require.resolve "./mod/#{name}.js"]
                console.log "[Info][Modules] #{name} was removed from cache"
        else
            console.log "[Info][Modules] Loading module #{name}"
        try
            moduleInit = require("./mod/#{name}.js").init
        catch error
            console.log "[Error][Modules] Error while loading #{name}"
            return 'Corrupted module'
        botModules.modules[name] = new BotModule name, moduleInit
        return 'Loaded successfully'
    unloadModule: (name) ->
        if !/mod([a-z0-9]+)/.test name
            console.log "[Error][Modules] #{name} is not module"
            return 'Not a module'
        if !botModules.modules[name]?
            console.log "[Error][Modules] #{name} is not loaded"
            return 'Not loaded'
        else
            console.log "[Info][Modules] Unloading module #{name}"
        delete botModules.modules[name]
        return 'Unloaded successfully'
    notifyHandlers: (event, reload) ->
        event.reload = reload
        for name, module of botModules.modules
            module.handleEvent event
            