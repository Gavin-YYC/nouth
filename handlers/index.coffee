Datastore = require 'nedb'

posts = new Datastore({filename:'database/posts.db'})
users = new Datastore({filename:'database/user.db'})


posts.loadDatabase (err)->
        console.log err if err

users.loadDatabase (err)->
        console.log err if err

exports.index = (req, res) ->
    posts.find({}).sort({date:-1}).limit(10).exec (err,docs)->
        res.render 'index',{
            user:{
                username:req.session.username
                uid: req.session.uid
                group: req.session.group
            }
            posts:docs
        }

exports.login = (req, res) ->
    res.render 'login'

exports.loginAction = (req, res) ->
    username = req.body.username
    password = req.body.password
    users.find({username:username,password:password},(err,docs)->
        if docs.length > 0
            req.session.username = username
            req.session.uid = docs[0].id
            req.session.group = docs[0].group
            res.redirect 'home/'+docs[0].id
        else
            res.render 'login', {
                err:{msg:"用户名或密码"}
            }
    )

exports.logout = (req, res) ->
    req.session.username = null
    req.session.uid = null
    req.session.group = null
    res.redirect '/'

exports.home = (req, res) ->
    if (req.session.username)
        res.render 'home',{
            user:{
                username:req.session.username
                uid: req.session.uid
                group: req.session.group
            }
        }

exports.post = (req, res) ->
    if req.query.page
        page = req.query.page
    else
        page = 1
    size = 20
    offset = size*(page-1)
    posts.find({}).sort({date:-1}).skip(offset).limit(size).exec (err,docs)->
        posts.count({},(err, count) ->
            res.render 'post',{
                user:{
                    username: req.session.username
                    uid: req.session.uid
                    group: req.session.group
                },
                posts:docs,
                pagination:{
                    count: count
                    page: page
                    pages: Math.ceil(count/size)
                }
            }
        )
exports.postNew = (req, res) ->
    newPost = req.body
    date = new Date
    newPost.date = date
    newPost.ip = req.connection.remoteAddress
    posts.insert newPost, (err,newDoc) ->
        console.log err if err
        res.send newDoc

exports.register = (req, res) ->
    res.render 'register'

exports.registerAction = (req, res) ->
    o = req.body
    console.log 0
    users.find({username: o.username},(err,docs) ->
        console.log 1
        console.log err if err
        if not docs.length
            id = (new Date()).getTime()
            users.insert({
                username: o.username
                password: o.password
                id: id
                group: 'user'
            })
            req.session.username = o.username
            console.log 2
            res.redirect 'home/'+id
            res.render 'home',{
                user:{
                    username: o.username
                    uid: id
                    group: 'user'
                }
            }
        else
            res.render 'register',{
                err:{msg:"该用户名已注册"}
            }
        )

exports.postAdmin = (req, res) ->
    posts.find({}).sort({date:-1}).exec (err,docs)->
        res.render 'index',{
            user:{
                username: req.session.username
                uid: req.session.uid
                group: req.session.group
            }
            posts:docs
        }
