_ = require 'underscore'

module.exports.init = ->
    insults = 'содомита|глиномеса|у(е|ё)(бка|бище)|пидор(ас)?а|школ(оту|ника)|пету(х|шк)а|хуесоса|говноеда|шлюху'
    commands =
        kickPrecise: setCommand([new RegExp("поставь ((#{insults}) с (ником|именем)|,? которого зовут) (.+),? на место", 'i'), new RegExp("(кик(ни)?|пни|выкин(и|ь)|убери|пидорни) (#{insults})( с (ником|именем)|,? которого зовут) (.+)", 'i')], [{name: 'who', regex: 0, match: 9}, {name: 'who', regex: 1, match: 12}], 'user')
        kickAlias:   setCommand([/(пни|выкин(и|ь)|кик(ни)?|убери|смой|пидорни) (.+)/i, /поставь (.+) на место/i], [{name: 'who', regex: 0, match: 4}, {name: 'who', regex: 1, match: 1}], 'user')    
    data =
        users:  []
        immune: ['Zero Maiden', 'Watch_Dacx', 'Amulonus']
    add = (regex, names) ->
        data.users.push
            regex: regex
            names: names
            id:    data.users.length
        return
    remove = (id) ->
        data.users = _.reject data.users, (user) ->
            user.id is id
        return
    add new RegExp("#{insults}|(б|в)илл?(и|а|ьяма)|фокса", 'i'), ['William Fox']
    add /бор(ея)|(ю)/i, ['Борей']
    add /диониса/i, ['Dionis']
    add /кошко((е|ё)б|фил)ов/i, ['Борей', 'Dionis']
    add /себя|бота/i, ->
        bot.cmd.say 'Анус себе кикни, пёс.'
        ['']
    add /дасха?(очку)?|дэш(и|у)|катю|е?катерину|няшу|вольнову(.*)/i, ->
        bot.cmd.say 'Я не пойду против своей госпожи.'
        ['']
    add /кошко((е|ё)б|фил)а/i, ->
        if Math.random()>.5 then ['Dionis'] else ['Борей']
    @registerHandler 'kickPrecise', 'talk', true,
    (event) ->
        testCommand commands.kickPrecise, event, yes
    ,
    (event) ->
        msg = parse.msg event
        who = parseCommand(commands.kickPrecise, testCommand(commands.kickPrecise, msg) - 1, msg).who
        if _.indexOf(data.immune, who) is -1
            bot.cmd.kick who, ''
        else
            bot.cmd.say 'Иди нахуй, маня.'
        return
    @registerHandler 'kick', 'talk', true,
    (event) ->
        testCommand commands.kickAlias, event, yes
    ,
    (event) ->
        msg = parse.msg event, yes
        who = parseCommand(commands.kickAlias, testCommand(commands.kickAlias, msg) - 1, msg).who
        for user in data.users
            if user.regex.test who
                if typeof user.names is 'function'
                    victims = user.names()
                else
                    victims = user.names
                for victim in victims
                    if _.indexOf(data.immune, victim) is -1
                        bot.cmd.kick victim, ''
                    else
                        bot.cmd.say 'Иди нахуй, маня.'
        return
    return