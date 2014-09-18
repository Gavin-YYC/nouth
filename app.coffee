bodyParser = require 'body-parser'
express = require 'express'
express-namespase = require 'express-namespace'
path = require 'path'

app = express()
app.set 'views', path.join __dirname, 'views'
app.set 'view engine', 'jade'
app.use express.static(path.join __dirname, 'public')
app.use express.responseTime()
app.use express.errorHandler({dumpExceptions: true, showStack: true})
app.use require('connect-assets')()
## bodyParser above app.router
app.use bodyParser.json()
app.use bodyParser.urlencoded()
app.use app.router
#jade format html
app.locals.pretty = true

routes = require('./routes')(app)

app.listen(8000)
console.log('Listening on port 8000')
