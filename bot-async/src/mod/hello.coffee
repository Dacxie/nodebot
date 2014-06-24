_ = require 'underscore'

module.exports.init = ->
    hello = [
        'драститя'
        'проходи, браток'
        'привет'
        'здравствуй, братишка, брат, браток'
    ]
    bye = [
        'пока'
        ':c'
        'ты куда?'
        'прощай'
    ]
    @registerHandler 'hello', 'user', false,
    (event) ->
        true
    ,
    (event) ->
        event = parse.user event
        switch event.type
            when 'IN'
                if event.name is bot.data.owner && event.uid?
                    bot.cmd.say event.name + ', ' + 'приветствую, госпожа'
                else
                    bot.cmd.say event.name + ', ' + _.sample hello
            when 'OUT'
                if event.name is bot.data.owner && event.uid?
                    bot.cmd.say event.name + ', ' + 'прощайте, госпожа'
                else
                    bot.cmd.say event.name + ', ' + _.sample bye
        return
    return