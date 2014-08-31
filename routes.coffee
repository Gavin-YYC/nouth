routes = require('./handlers')

module.exports = (app) ->
    app.get '/', routes.index
