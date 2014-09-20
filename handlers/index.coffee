Datastore = require 'nedb'
posts = new Datastore({filename:'database/posts.db'})
posts.loadDatabase (err)->
        console.log err if err

exports.index = (req, res) ->
    posts.find({}).sort({date:-1}).limit(10).exec (err,docs)->
        res.render 'index',{posts:docs}

exports.login = (req, res) ->
    res.render 'login'

exports.loginAction = (req, res) ->
    username = req.body.username
    password = req.body.password
   # db.find({username:username,password:password},(err,docs)->
   #     if docs.length > 0
   #         res.redirect 'home'
   #     else
   #         res.render 'index'
   # )
        
exports.loginSuccess = (req, res) ->
    res.send 'success'

exports.loginFailure = (req, res) ->
    res.send 'failure'

exports.home = (req, res) ->
    res.render 'home'

exports.postNew = (req, res) ->
    newPost = req.body
    date = new Date
    newPost.date = date
    newPost.ip = req.connection.remoteAddress
    posts.insert newPost, (err,newDoc) ->
        console.log err if err
        res.send newDoc
