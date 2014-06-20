module.exports.init = ->
    storage = @localStorage
    storage.users = []
    regex =
        preciseKickA: /поставь (содомита|у(е|ё)бка|пидор(ас)?а|школьника|шлюху|хуесоса|говноеда)( с (ником|именем)|,? которого зовут) (.+),? на место/i
        preciseKickB: /(кик(ни)?|пни|выкин(и|ь)|убери|пидорни) (содомита|у(е|ё)бка|пидор(ас)?а|школьника|шлюху|хуесоса|говноеда)( с (ником|именем)|,? которого зовут) (.+)/i
        aliasKickA: /(пни|выкин(и|ь)|кик(ни)?|убери|смой|пидорни) (.+)/i
        aliasKickB: /поставь (.+) на место/i
        userWilliam: /(содомита|(б|в)илл?(и|а|ьяма)|пидор(ас)?а|у(е|ё)бка|школьника|хуесоса|говноеда)(.*)/i
        userDacxie: /(дасха?(очку)?|дэш(и|у)|катю|е?катерину|няшу|вольнову)(.*)/i
        userBot: /(себя|бота)/i
        userBorey: /(бор(ея)|(ю))/i
        userCatsters: /(кошко((е|ё)б|фил)ов)/i
        userCatster: /кошко((е|ё)б|фил)а/i
        userGrumpy: /гр(а|е)мпи/i
    addUser = (regexp, names) ->
        storage.users.push
            regexp: regexp
            names:  names
            id:     storage.users.length
        return
    removeUser = (id) ->
        storage.users = _.reject storage.users, (data) ->
            data.id is id
        return
    addUser regex.userWilliam, ['William Fox']
    addUser regex.userDacxie, ['Zero Maiden', 'Watch_Dacx']
    addUser regex.userBot, ->
        botCommand.say 'Бот ли я дрожащий или право имею...'
        ['GorisBorit']
    addUser regex.userBorey, ['Борей']
    addUser regex.userCatsters, ['Dionis', 'Борей']
    addUser regex.userGrumpy, ['Grumpy cat']
    addUser regex.userCatster, ->
        if Math.random()>.5 then ['Dionis'] else ['Борей']
    @registerEventHandler true, 'kickSomeonePrecise', 'msgToMe',
    (event) ->
        msg = parse.msg event, yes
        (msg.role isnt 'user') && ((regex.preciseKickA.test msg.text) || (regex.preciseKickB.test msg.text))
    ,
    (event) ->
        msg = parse.msg event, yes
        if regex.preciseKickA.test msg.text
            who = msg.text.match(regex.preciseKickA)[6]
        else
            who = msg.text.match(regex.preciseKickB)[9]
        botCommand.kick who, ''
        return
    @registerEventHandler true, 'kickSomeone', 'msgToMe',
    (event) ->
        msg = parse.msg event, yes
        (msg.role isnt 'user') && ((regex.aliasKickA.test msg.text) || (regex.aliasKickB.test msg.text))
    ,
    (event) ->
        msg = parse.msg event, yes
        if regex.aliasKickB.test msg.text
            who = msg.text.match(regex.aliasKickB)[1]
        else
            who = msg.text.match(regex.aliasKickA)[4]
        for user in storage.users
            if user.regexp.test who
                if typeof user.names is 'function'
                    victims = user.names()
                else
                    victims = user.names
                for victim in victims
                    botCommand.kick victim, ''
        return