botCommands.push(
    {
        metConditions: function(message) {
            return (message.author.right === 'admin');
        },
        perform: function(message) {
            botSay('Yay! It works.');
        }
    }
);