exports.index = (req, res) ->
    res.render 'index'

exports.login = (req, res) ->
    res.render 'login'

exports.loginAction = (req, res) ->
    if req.body.username == 'admin'
        res.render 'index'
        
exports.loginSuccess = (req, res) ->
    res.send 'success'

exports.loginFailure = (req, res) ->
    res.send 'failure'

exports.home = (req, res) ->
    res.render 'home'
