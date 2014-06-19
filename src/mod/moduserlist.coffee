_ = require 'underscore'

module.exports.init = ->
    botData.online = []
    addUser = (name) ->
        botData.online = _.without botData.online, name
        botData.online.push name
    removeUser = (name) ->
        botData.online = _.without botData.online, name
    @registerEventHandler false, 'userEvent', 'user',
    (event) ->
        true
    ,
    (event) ->
        event = parse.user event
        switch event.type
            when 'IN'
                addUser event.name
            when 'OUT'
                removeUser event.name
        return
    @registerEventHandler false, 'getList', 'msgToMe',
    (event) ->
        msg = parse.msg event
        (/onlinelist/.test msg.text) && !msg.old
    ,
    (event) ->
        botCommand.say JSON.stringify botData.online
        return