addBotEvent(
    'moduleLoad'
    ,
    (messageData) ->
        (messageData.text.match /module load ([a-z0-9-]+)/) && (messageData.author.right is 'admin')
    ,
    (messageData) ->
        module = messageData.text.match(/module load ([a-z0-9-]+)/)[1]
        botSay 'Loading module ' + module
        botSay if loadModule module then 'Loaded successfully' else 'Cannot load ' + module
)