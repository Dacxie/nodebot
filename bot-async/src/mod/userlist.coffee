_ = require 'underscore'

module.exports.init = ->
    commands =
        list: setCommand([/^onlinelist display/], [], 'admin')
    bot.data.online = []
    add = (name) ->
        bot.data.online = _.without bot.data.online, name
        bot.data.online.push name
        return
    remove = (name) ->
        bot.data.online = _.without bot.data.online, name
        return
    @registerHandler 'changedList', 'user', false,
    (event) ->
        true
    ,
    (event) ->
        user = parse.user event
        switch user.type
            when 'IN'
                add user.name
            when 'OUT'
                remove user.name
        return
    @registerHandler 'displayList', 'talk', false,
    (event) ->
        testCommand commands.list, event, yes
    ,
    (event) ->
        bot.cmd.say JSON.stringify bot.data.online
        return