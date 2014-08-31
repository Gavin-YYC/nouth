routes = require('./handlers')

module.exports = (app) ->
    app.namespace '/',->
        app.get '/', routes.index
        app.get 'login', routes.login
        app.get 'home', routes.home
