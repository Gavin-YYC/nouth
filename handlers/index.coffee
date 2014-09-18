Datastore = require 'nedb'
db = new Datastore({filename:'taolijie.db'})
db.loadDatabase (err)->
        console.log 'hello nedb'
user = {
    username:"admin"
    password:"123"
}
db.insert user,(err,newDoc)->

exports.index = (req, res) ->
    res.render 'index'

exports.login = (req, res) ->
    res.render 'login'

exports.loginAction = (req, res) ->
    #if req.body.username == 'admin'
    #    res.render 'index'
    username = req.body.username
    db.find({username:username},(err,docs)->
        console.log res.render 'home'
    )
        
exports.loginSuccess = (req, res) ->
    res.send 'success'

exports.loginFailure = (req, res) ->
    res.send 'failure'

exports.home = (req, res) ->
    res.render 'home'
