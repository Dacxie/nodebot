addBotEvent(
    (messageData) ->
        (messageData.text.indexOf('testing') >= 0)
    ,
    (messageData) ->
        botSay "Test: #{messageData.author.name}:#{messageData.author.right}"
        return
)
addBotEvent(
    (messageData) ->
        ((messageData.text.indexOf('events reload') is 0) &&
         (messageData.author.name is botData.ownerName))
    ,
    (messageData) ->
        botSay 'Reloading...'
        reloadBotEvents()
        botSay 'Done.'
        return
)