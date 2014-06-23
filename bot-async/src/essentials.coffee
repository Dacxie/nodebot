# Included in bot

String::contains = () ->
    String::indexOf.apply(this, arguments) isnt -1
    
String::starts = () ->
    String::indexOf.apply(this, arguments) is 0

String::strip = () ->
    @replace(/<(.|\n)*?>/g, '').replace(/&gt;/g, '>').replace(/&lt;/g, '<').replace(/&amp;/g, '&')

bot.cmd =
    say: (text, callback) ->
        api.msg bot.data.key, bot.data.chat, text, (error, data) ->
            if callback?
                callback error, data
            else
                return
        return
    kick: (who, why, callback) ->
        api.kick bot.data.key, bot.data.chat, who, why, (error, data) ->
            if callback?
                callback error, data
            else
                return
        return
    ban: (who, why, time, clear, callback) ->
        api.ban bot.data.key, bot.data.chat, who, why, time, clear, (error, data) ->
            if callback?
                callback error, data
            else
                return
        return
    warn: (who, why, callback) ->
        api.warn bot.data.key, bot.data.chat, who, why, (error, data) ->
            if callback?
                callback error, data
            else
                return
        return
    status: (status, callback) ->
        api.status bot.data.key, bot.data.chat, status, (error, data) ->
            if callback?
                callback error, data
            else
                return
        return
    color: (color, callback) ->
        api.color bot.data.key, bot.data.chat, color, (error, data) ->
            if callback?
                callback error, data
            else
                return
        return
    logout: (callback) ->
        api.logout bot.data.key, bot.data.chat, (error, data) ->
            if callback?
                callback error, data
            else
                return
        return
    
@parse =
    msg: (event, toMe) ->
        data =
            processed: yes
            text: event.text.replace((if toMe then new RegExp("#{bot.data.name}, ?", 'i') else ''), '')
            from: event.from
            role: if event.fl? then event.fl else 'user'
            id: event.id
            old: event.reload
    user: (event) ->
        data =
            processed: yes
            type: event.event
            name: event.user.name
            id: event.user.regId
            old: event.reload
            
getRole = (role) ->
    int = -1
    switch role
        when 'user'
            int = 0
        when 'moder'
            int = 1
        when 'admin'
            int = 2
    int
    
@setCommand = (regexes, groups, role) ->
    command =
        regexes:    regexes
        groups:     groups
        role:       role
        
@testCommand = (command, message, talk) ->
    if talk?
        message = parse.msg message, talk
    match = 0
    for regex, index in command.regexes
        match = index + 1 if regex.test(message.text)
    return no if match is 0
    return no if message.old
    return no if (getRole(message.role) < getRole(command.role)) && message.from isnt bot.data.owner
    return match
    
@parseCommand = (command, regex, message, talk) ->
    if talk?
        message = parse.msg message, talk
    return null if !testCommand command, message
    matches = message.text.match command.regexes[regex]
    result = {}
    for group in command.groups
        if group.regex is regex
            result[group.name] = matches[group.match]
    result
            