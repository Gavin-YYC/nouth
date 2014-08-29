express = require 'express'
path = require 'path'
app = express()

app.set 'views', path.join __dirname, 'views'
app.set 'view engine', 'jade'
app.use(express.static(path.join __dirname, 'public'))
app.use require('connect-assets')()

app.get '/', (req, res) ->
    res.render 'index'

app.get '/login', (req, res) ->
    res.render 'login'

app.get '/home', (req, res) ->
    res.render 'home'

app.listen(8000)
console.log('Listening on port 8000')
