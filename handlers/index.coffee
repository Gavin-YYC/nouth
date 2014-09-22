Datastore = require 'nedb'

posts = new Datastore({filename:'database/posts.db'})
users = new Datastore({filename:'database/user.db'})


posts.loadDatabase (err)->
        console.log err if err

users.loadDatabase (err)->
        console.log err if err

exports.index = (req, res) ->
    posts.find({}).sort({date:-1}).limit(10).exec (err,docs)->
        console.log req.session.username
        res.render 'index',{
            user:{username:req.session.username},
            posts:docs
        }

exports.login = (req, res) ->
    res.render 'login'

exports.loginAction = (req, res) ->
    username = req.body.username
    password = req.body.password
    req.session.username = username
    console.log username
    users.find({username:username,password:password},(err,docs)->
        if docs.length > 0
            res.redirect 'home'
        else
            res.render 'login', {
                err:{msg:"用户名或密码"}
            }
    )

exports.home = (req, res) ->
    if (req.session.username)
        res.render 'home',{user:{
            username:req.session.username
        }}

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
                    username:'admin'
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
    users.find({username: o.username},(err,docs) ->
        console.log err if err
        if not docs.length
            id = (new Date()).getTime()
            users.insert({
                username: o.username
                password: o.password
                id: id
            }
            (err,docs) ->
                console.log 'new user added'
                console.log err if err
                req.session.username = o.username
                res.redirect 'home'
            )
        else
            res.render 'register',{
                err:{msg:"该用户名已注册"}
            }
        )
