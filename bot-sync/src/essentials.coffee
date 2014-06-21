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
    
@parse =
    msg: (event, toMe) ->
        data =
            text: event.text.replace((if toMe then new RegExp("#{bot.data.name}, ?", 'i') else ''), '')
            from: event.from
            role: if event.fl? then event.fl else 'user'
            id: event.id
            old: event.reload
    user: (event) ->
        data =
            type: event.event
            name: event.user.name
            id: event.user.regId
            old: event.reload
            
@adminCommand = (message, regex) ->
    regex.test(message.text) && message.role is 'admin' && !message.old