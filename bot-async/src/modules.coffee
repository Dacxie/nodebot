class @BotModule
    constructor: (name, init) ->
        @name = name
        @data = {}
        @handlers =
            all:  {}
            user: {}
            msg:  {}
            talk: {}
        init.apply this
    log: (type, data) ->
        console.log "[#{type}][Modules][#{@name}] #{data}"
        return
    registerHandler: (name, type, conflict, condition, handler) ->
        if !@handlers[type]?
            @log 'Error', 'In registerHandler: Invalid type: ' + type
            return
        if @handlers[type][name]?
            @log 'Warning', 'In registerHandler: Overwriting handler: ' + name
        else
            @log 'Info', 'In registerHandler: Creating handler: ' + name
        @handlers[type][name] =
            conflict:  conflict
            condition: condition
            handler:   handler
        return
    notify: (event, type, status) ->
        if !@handlers[type]?
            @log 'Error', 'In notify: Invalid type: ' + type
            return
        conflict = false
        try
            for name, handler of @handlers[type]
                if handler.condition(event) && !((conflict || status.conflict[type]) && handler.conflict)
                    if handler.conflict
                        conflict = true
                        status.conflict[type] = true
                    handler.handler event
        catch error
            console.log '[Error][Modules] Catched in ' + @name + '.notify'
            console.log '[Error][Modules] ' + error
        return
    handle: (event, status) ->
        @notify event, 'all', status
        if event.t is 'msg'
            @notify event, 'msg', status
            if event.text.starts bot.data.name + ','
                @notify event, 'talk', status
        if event.t is 'user'
            @notify event, 'user', status
        return
bot.modules =
    loaded: {}
    load: (name, callback) ->
        if !/[a-z0-9-]+/.test name
            console.log '[Error][Modules] In load: Invalid module name: ' + name
            callback null, {error: 'Invalid name'}
            return
        if !fs.existsSync "./bin/mod/#{name}.js"
            console.log '[Error][Modules] In load: Module not found: ' + name
            callback null, {error: 'Not found'}
            return
        if bot.modules.loaded[name]?
            console.log '[Error][Modules] In load: Module is already loaded: ' + name
            callback null, {error: 'Already loaded'}
            return
        console.log '[Info][Modules] In load: Loading module: ' + name
        try
            init = require("./mod/#{name}.js").init
        catch exception
            console.log '[Error][Modules] In load: Load error: ' + name
            console.log "[Error][Modules] #{exception}"
            delete bot.modules.loaded[name]
            if require.cache[require.resolve "./mod/#{name}.js"]
                delete require.cache[require.resolve "./mod/#{name}.js"]
                console.log '[Info][Modules] In load: Deleted cache of ' + name
            callback null, {error: 'Load error'}
            return
        try
            bot.modules.loaded[name] = new BotModule name, init
        catch exception
            console.log '[Error][Modules] In load: Error in module: ' + name
            console.log '[Error][Modules] In load: ' + exception
            delete bot.modules.loaded[name]
            if require.cache[require.resolve "./mod/#{name}.js"]
                delete require.cache[require.resolve "./mod/#{name}.js"]
                console.log '[Info][Modules] In load: Deleted cache of ' + name
            callback null, {error: 'Error in module'}
            return
        console.log '[Info][Modules] In load: Loaded: ' + name
        callback null, 1
        return
    unload: (name, callback) ->
        if !/[a-z0-9-]+/.test name
            console.log '[Error][Modules] In unload: Invalid module name: ' + name
            callback null, {error: 'Invalid name'}
            return
        if !bot.modules.loaded[name]?
            console.log '[Error][Modules] In unload: Module not loaded: ' + name
            callback null, {error: 'Not loaded'}
            return
        delete bot.modules.loaded[name]
        if require.cache[require.resolve "./mod/#{name}.js"]
            delete require.cache[require.resolve "./mod/#{name}.js"]
            console.log '[Info][Modules] In unload: Deleted cache of ' + name
        else
            console.log '[Warning][Modules] In unload: Unable to access cache of ' + name
        console.log '[Info][Modules] In unload: Unloaded module: ' + name
        callback null, 1
        return
    reload: (name, callback) ->
        console.log '[Info][Modules] In reload: Reloading: ' + name
        bot.modules.unload name, (error, data) ->
            if data.error?
                callback null, {error: data.error}
                return
            if data is 1
                bot.modules.load name, (error, data) ->
                    if data.error?
                        callback null, {error: data.error}
                        return
                    if data is 1
                        console.log '[Info][Modules] In reload: Reloaded: ' + name
                        callback null, 1
                        return
                    return
            else
                callback null, {error: 'Something is wrong'}
            return
        return
    notify: (event, reload) ->
        event.reload = reload
        status = {conflict: {all: no, talk: no, user: no, msg: no}}
        for name, module of bot.modules.loaded
            try
                module.handle event, status
            catch error
                console.log '[Error][Modules] Catched in modules.notify'
                console.log '[Error][Modules] ' + error
        delete event
        return