# This file is included in bot.coffee

@parse =
    msgToMe: (event) ->
        text = event.text.replace botData.username + ',', ''
        text = text.substr 1 if text[0] is ' '
        messageData =
            text: text
            author:
                name:  event.from
                right: if event.fl? then event.fl else 'user'