Datastore = require 'nedb'
db = new Datastore({filename:'taolijie.db'})
db.loadDatabase (err)->
        console.log 'Database loaded'
user = {
    username:"admin"
    password:"123"
}
db.insert user,(err,newDoc)->

exports.index = (req, res) ->
    db.find({},(err,docs)->
        res.render 'index',docs
    )

exports.login = (req, res) ->
    res.render 'login'

exports.loginAction = (req, res) ->
    username = req.body.username
    password = req.body.password
    db.find({username:username,password:password},(err,docs)->
        if docs.length > 0
            res.redirect 'home'
        else
            res.render 'index'
    )
        
exports.loginSuccess = (req, res) ->
    res.send 'success'

exports.loginFailure = (req, res) ->
    res.send 'failure'

exports.home = (req, res) ->
    res.render 'home'
