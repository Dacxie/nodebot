module.exports.init = ->
    @registerEventHandler false, 'kickSomeone', 'msgToMe',
    (event) ->
        /(по нику )?(kick|кик(ни)?|пни|выкин(и|ь)|убери)(.+)/i.test parse.msgToMe(event).text
    ,
    (event) ->
        who = parse.msgToMe(event).text.match(/(по нику )?(kick|кик(ни)?|пни|выкин(и|ь))(.+)/i)[5]
        console.log who
        if /^(по нику )(.+)/i.test parse.msgToMe(event).text
            botKick who.substr(1), ''
            return
        if /(((б|в)илл?(и|а|ьяма))|(пидор(ас)?а)|(уебка)|(школьника))(.*)/i.test who
            botKick 'William Fox', ''
        else if /((дасха?(очку)?)|(дэш(и|у))|(катю)|(е?катерину)|(няшу)|(вольнову))(.*)/i.test who
            botKick 'Zero Maiden', ''
        else if /(бор(ея)|(ю))/i.test who
            botKick 'Борей', ''
        else if /(кошко((е|ё)б|фил)а)/i.test who
            botKick((if Math.random()<.5 then 'Борей' else 'Dionis'), '')
        else if /(кошко((е|ё)б|фил)ов)/i.test who
            botKick 'Dionis', ''
            botKick 'Борей', ''