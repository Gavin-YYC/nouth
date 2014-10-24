Datastore = require 'nedb'

posts = new Datastore({filename:'database/post.db'})
users = new Datastore({filename:'database/user.db'})
categories = new Datastore({filename:'database/category.db'})


posts.loadDatabase (err)->
        console.log err if err

users.loadDatabase (err)->
        console.log err if err

categories.loadDatabase (err)->
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
            if docs[0].group == 'admin'
                res.redirect 'home'
            else
                res.redirect '/admin/post'
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
    res.render 'home',{
        user:{
            username: req.session.username
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
    console.log newPost.content
    date = new Date
    newPost.date = date
    newPost.ip = req.connection.remoteAddress
    newPost.uid = req.session.uid if req.session.uid
    newPost.id= date.getTime()
    posts.insert newPost, (err,newDoc) ->
        console.log err if err
        res.send newDoc

exports.postRemove = (req, res) ->
    o = req.body
    id = parseInt(o.id)
    console.log id
    posts.remove({id:id},{},(err,num) ->
        console.log err if err
        console.log num+' post removed'
    )

exports.postUpdate = (req, res) ->
    o = req.body
    new_o = {}
    id = parseInt(o.id)
    new_o.category = o.category
    new_o.title = o.title
    new_o.content = o.content
    console.log new_o
    posts.update({id:id},{$set:new_o},{},(err,num) ->
        console.log err if err
        console.log num+' post update'
    )

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
                group: 'user'
            })
            req.session.username = o.username
            req.session.uid = id
            res.redirect '/'
            #res.render 'home',{
            #    user:{
            #        username: o.username
            #        uid: id
            #        group: 'user'
            #    }
            #}
        else
            res.render 'register',{
                err:{msg:"该用户名已注册"}
            }
        )

exports.postAdmin = (req, res) ->
    if (req.session.username)
        if req.query.page
            page = req.query.page
        else
            page = 1
        size = 20
        offset = size*(page-1)
        
        spec = {}
        if req.session.group != "admin"
            spec = {uid:req.session.uid}
            
        posts.find(spec).sort({date:-1}).skip(offset).limit(size).exec (err,docs)->
            posts.count({},(err, count) ->
                res.render 'postAdmin',{
                    user:{
                        username: req.session.username
                        uid: req.session.uid
                        group: req.session.group
                    }
                    posts:docs,
                    pagination:{
                        count: count
                        page: page
                        pages: Math.ceil(count/size)
                    }
                }
            )


exports.categoryAdmin = (req, res) ->
    categories.find({}).sort({date:1}).exec (err,docs)->
    #categories.find({},(err, docs)->
        res.render 'categoryAdmin',{
            user:{
                username: req.session.username
                uid: req.session.uid
                group: req.session.group
            }
            categories: docs,
        }
    #)

exports.categoryNew = (req, res) ->
    o = req.body
    categories.insert o, (err,newDoc) ->
        console.log err if err
        res.send newDoc

exports.categoryUpdate = (req, res) ->
    o = req.body
    id = o.id
    console.log 'update ' + o.id + ' ' + o.name
    categories.update({id:id},{$set:o},{},(err,num) ->
        console.log err if err
        console.log num + 'category updated'
    )

exports.categoryRemove = (req, res) ->
    id = req.body.id
    categories.remove({id:id},{},(err, num)->
        console.log num + ' category removed'
    )
