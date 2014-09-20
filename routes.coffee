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
        app.post 'new',routes.postNew
