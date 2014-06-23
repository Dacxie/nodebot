http = require 'http'
url  = require 'url'
path = require 'path'
hash = require 'crypto'

password = '9ac47ce9482862df7560842e4f98198c'

processPost = (response, act, data, callback) ->
    return if !/((bot|api|mod)\.[a-z]+)/.test act
    act = act.match(/((bot|api|mod)\.[a-z]+)/)[1]
    console.log "[Info][Server] Command: #{act}"
    switch act
        when 'bot.login'
            if !bot.data.logged
                bot.login ->
        when 'bot.logout'
            if bot.data.logged
                bot.cmd.logout()
        when 'bot.relogin'
            if bot.data.logged
                bot.cmd.logout ->
                    bot.login ->
                        bot.action() if !bot.data.logged
        when 'mod.load'
            if data['mod']? && bot.data.logged
                bot.modules.load data['mod'], (error, status) ->
                    response.write data['callback'] + '(' + JSON.stringify(status) + ')' if data['callback']
        when 'mod.unload'
            if data['mod']? && bot.data.logged
                bot.modules.unload data['mod'], (error, status) ->
                    response.write data['callback'] + '(' + JSON.stringify(status) + ')' if data['callback']
        when 'mod.reload'
            if data['mod']? && bot.data.logged
                bot.modules.reload data['mod'], (error, status) ->
                    response.write data['callback'] + '(' + JSON.stringify(status) + ')' if data['callback']
        when 'api.msg'
            if data['msg']? && bot.data.logged
                bot.cmd.say data['msg']
        when 'api.status'
            if data['status']? && bot.data.logged
                bot.cmd.status data['status']
        when 'api.color'
            if data['color']? && bot.data.logged
                bot.cmd.color data['color']
        when 'api.kick'
            if data['who']? && data['why']? && bot.data.logged
                bot.cmd.kick data['who'], data['why']
        when 'api.ban'
            if data['who']? && data['why']? && data['time']? && data['clear']? && bot.data.logged
                bot.cmd.ban data['who'], data['why'], data['time'], data['clear']
        when 'api.warn'
            if data['who']? && data['why']? && bot.data.logged
                bot.cmd.warn data['who'], data['why']
    callback()
    return
        
http.createServer (request, response) ->
    data = url.parse(request.url, true).query
    response.writeHead(200, 'OK', {'Content-Type': 'text/plain'})
    if hash.createHash('md5').update(query.auth).digest('hex') is password
        processPost response, path.basename(request.url), data, ->
            response.end()
    else
        if data['callback']
            response.write data['callback'] + '({error: \'invalidAuth\'})'
        else
            response.write '{error: \'invalidAuth\'}'
        response.end()
.listen 4234

console.log '[Info][Server] Listening at :4234'