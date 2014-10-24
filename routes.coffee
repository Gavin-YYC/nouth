routes = require('./handlers')

module.exports = (app) ->
    app.namespace '/', ->
        app.get '/', routes.index
        app.get 'home', routes.home

    app.namespace '/login', ->
        app.get '/', routes.login
        app.post '/', routes.loginAction
        app.get 'success', routes.loginSuccess
        app.get 'failure', routes.loginFailure

    app.namespace '/post', ->
        app.get '/',routes.post
        app.post 'new',routes.postNew
        app.post 'remove',routes.postRemove
        app.post 'update',routes.postUpdate

    app.namespace '/category', ->
        app.post 'new',routes.categoryNew
        app.post 'remove',routes.categoryRemove
        app.post 'update',routes.categoryUpdate

    app.namespace '/register', ->
        app.get '/',routes.register
        app.post '/',routes.registerAction

    app.namespace '/home', ->
        app.get '/:uid',routes.home

    app.namespace '/admin', ->
        app.get '/post',routes.postAdmin
        app.get '/user',routes.userAdmin
        app.get '/category',routes.categoryAdmin

    app.namespace '/logout', ->
        app.get '/:uid', routes.logout
