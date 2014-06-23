fs = require 'fs'
_  = require 'underscore'

module.exports.init = ->
    commands =
        klPost:    setCommand([/^kicklist post/i, /покажи (список )?кого (кикаешь|пинаешь)/i], [], 'admin')
        klPush:    setCommand([/^kicklist push (.+)/i, /кикай (.+)/i], [{name: 'name', regex: 0, match: 1}, {name: 'name', regex: 1, match: 1}], 'admin')
        klPop:     setCommand([/^kicklist pop (.+)/i, /не кикай (.+)/i], [{name: 'name', regex: 0, match: 1}, {name: 'name', regex: 1, match: 1}], 'admin')
        cmEnter:   setCommand([/^(войди|зайди)/i], [], 'user')
        cmLeave:   setCommand([/^(выйди|уйди)/i], [], 'user')
        cmRelogin: setCommand([/^(остановись|перезайди)/i], [], 'user')
        tlTo:      setCommand([/^поговори с (.+)/i], [{name: 'name', regex: 0, match: 1}], 'user')
    ai =
        kicklist: []
        clear: (string) ->
            result = ''
            result += char for char in string when /[a-z0-9а-я]/i.test char
            result
        questions: 'кто, что, какой, какая, какое, какие, каков, чей, чьи, чья, который, которая, которое, которые, сколько, как, где, куда, когда, чему, чего, чем, кем'.split ', '
        base:
            array: []
            name:  ''
            load: (file) ->
                ai.base.array = fs.readFileSync(file).toString().split '\n'
                ai.base.name  = ''
                return
            get:  (req) ->
                question = true for word in ai.questions when req.toLowerCase().contains word
                return _.sample(['Да', 'Нет', 'Не знаю', 'Реши сам']) if !question && req.contains '?'
                return Math.round(Math.random() * 300) if req.contains('?') && req.toLowerCase().contains 'сколько'
                result = []
                for phrase, index in ai.base.array
                    if ai.clear(phrase).contains(ai.clear req) || ai.clear(req).contains ai.clear phrase
                        result.push ai.base.array[index + 1]
                return 0 if result.length is 0
                _.sample result
            rand: ->
                _.sample ai.base.array
        
    @registerHandler 'kicklistPost', 'talk', true,
    (event) ->
        testCommand commands.klPost, event, yes
    ,
    (event) ->
        list = ''
        for name in ai.kicklist
            if list isnt ''
                list += ', '
            list += name
        list = 'Список петухов: ' + list
        if list.length > 300
            loop
                bot.cmd.say list
                list = list.substr 300
                break if list.length <= 300
        bot.cmd.say list
        return

    @registerHandler 'kicklistPush', 'talk', true,
    (event) ->
        testCommand commands.klPush, event, yes
    ,
    (event) ->
        who = parseCommand(commands.klPush, testCommand(commands.klPush, event, yes) - 1, event, yes).name
        ai.kicklist = _.without ai.kicklist, who
        ai.kicklist.push who
        bot.cmd.say 'Так ему и надо!'
        return

    @registerHandler 'kicklistPop', 'talk', true,
    (event) ->
        testCommand commands.klPop, event, yes
    ,
    (event) ->
        who = parseCommand(commands.klPop, testCommand(commands.klPop, event, yes) - 1, event, yes).name
        ai.kicklist = _.without ai.kicklist, who
        bot.cmd.say 'Есть, мэм.'
        return

    @registerHandler 'enterCommand', 'talk', true,
    (event) ->
        !bot.data.logged && testCommand commands.cmEnter, event, yes
    ,
    (event) ->
        bot.login ->
        return

    @registerHandler 'leaveCommand', 'talk', true,
    (event) ->
        bot.data.logged && testCommand commands.cmLeave, event, yes
    ,
    (event) ->
        bot.cmd.logout()
        return

    @registerHandler 'reloginCommand', 'talk', true,
    (event) ->
        testCommand commands.cmRelogin, event, yes
    ,
    (event) ->
        bot.cmd.logout ->
            bot.login ->
                bot.action() if !bot.data.logged
        return

    @registerHandler 'talkTo', 'talk', true,
    (event) ->
        testCommand commands.tlTo, event, yes
    ,
    (event) ->
        event = parse.msg event, yes
        who = parseCommand(commands.tlTo, 0, event).name
        bot.cmd.say who + ', ' + ai.base.get event.text
        return

    @registerHandler 'talk', 'talk', true,
    (event) ->
        event = parse.msg event
        event.from isnt bot.data.name
    ,
    (event) ->
        event = parse.msg event, yes
        msg = ai.base.get event.text
        if msg is 0
            bot.cmd.say event.from + ', Мне нечего сказать.'
        else
            bot.cmd.say event.from + ', ' + msg
        return

    @registerHandler 'kicklistTest', 'user', false,
    (event) ->
        event = parse.user event
        event.type is 'IN' && !event.old
    ,
    (event) ->
        event = parse.user event
        bot.cmd.kick event.name if _.indexOf(ai.kicklist, event.name) >= 0
        return
    
    ai.base.load 'base.mad'
    
    return