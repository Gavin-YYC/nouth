Datastore = require 'nedb'

posts = new Datastore({filename:'database/posts.db'})
users = new Datastore({filename:'database/user.db'})


posts.loadDatabase (err)->
        console.log err if err

users.loadDatabase (err)->
        console.log err if err

exports.index = (req, res) ->
    posts.find({}).sort({date:-1}).limit(10).exec (err,docs)->
        res.render 'index',{posts:docs}

exports.login = (req, res) ->
    res.render 'login'

exports.loginAction = (req, res) ->
    username = req.body.username
    password = req.body.password
    users.find({username:username,password:password},(err,docs)->
        if docs.length > 0
            res.redirect 'home'
        else
            res.redirect 'login'
    )
        
exports.loginSuccess = (req, res) ->
    res.send 'success'

exports.loginFailure = (req, res) ->
    res.send 'failure'

exports.home = (req, res) ->
    res.render 'home'

exports.post = (req, res) ->
    if req.query.page
        page = req.query.page
    else
        page = 1
    size = 20
    offset = size*(page-1)
    posts.find({}).sort({date:-1}).skip(offset).limit(size).exec (err,docs)->
        posts.count({},(err, count) ->
            console.log count
            res.render 'post',{posts:docs,pagination:{
                count: count
                page: page
                pages: Math.ceil(count/size)
            }}
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
            users.insert({username: o.username,password: o.password},(err,docs) ->
                console.log 'new user added'
                console.log err if err
                res.redirect 'home'
            )
        else
            res.redirect 'register'
        )
