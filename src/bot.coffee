nd = require('./api').api #NoDelic

# Bot V0.1.0 - Dacx

# Usage: node bot <username> <password> <chat>
bi =
    ownr: process.argv[5]
    name: process.argv[2]
    pass: process.argv[3]
    chat: process.argv[4]
    skey: null
    ismd: null
    
cc = []

ac = (mc, oc) ->
    cc.push
        mc: mc
        oc: oc
        
ac(
    (md) ->
        (md.qt.indexOf('поговори с ') is 0)
    , 
    (md) ->
        nd.msg bi.skey, bi.chat, "#{md.qt.substr md.qt.indexOf 'поговори с '}, Мне нечего сказать."
        return
)
ac(
    (md) ->
        (md.qt.indexOf('someadminstuff') is 0 && md.au.rg is 'admin')
    ,
    (md) ->
        nd.msg bi.skey, bi.chat, 'admin'
        return
)
    
li = ->
    nr = nd.login bi.name, bi.pass, bi.chat
    if nr.status isnt 'success'
        console.log '[Fatal] Cannot login to chat.'
        process.exit 1
    bi.skey = nr._
    bi.ismd = (nr.moder? || nr.admin?)
    console.log "Logged in, moderator = #{bi.ismd}"
li()

ga = (t) ->
    md =
        qt: t.text.replace(bi.name + ',', '')
        tx: t.text
        au:
            nm: t.from
            rg: if !t.fl? then 'user' else t.fl
    md.qt = md.qt.substr(1) if md.qt[0] is ' '
    for ev in cc
        if ev.mc md
            ev.oc md
    
pl = (r) ->
    if r.t is 'msg'
        if r.text.indexOf(bi.name + ',') is 0
            ga r
            
bl = ->
    lr = nd.listen bi.skey, bi.chat
    for m in lr.m
        if m.status is 'mustlogin'
            console.log '[Danger] Kicked out of chat. Logging in'
            li()
        else
            pl m
    bl()
bl()