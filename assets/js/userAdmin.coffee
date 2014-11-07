$('.ui.modal.user').modal('attach events','#user-new-btn','show')
$('.ui.radio.checkbox').checkbox();

avalon.define "users",(v)->
	v.users = users
	for i in users
		i.edit = 0
	
	v.origin = {}
	v.edit = (o)->
		v.origin = o
		o.edit = !o.edit

	v.cancel = (o)->
		o.edit = !o.edit

	v.submit = (o)->
		o.edit = !o.edit
		$.post('/user/update',{id:o.id,password:o.password,group:o.group},()->
			console.log "update"+o.id
		)

	v.remove = (rm,o)->
		rm()
		console.log o.id
		$.post('/user/remove',{id:o.id},()->
			console.log "remove"+o.id
		)


avalon.define "users_new",(v)->
	v.o = {
		username:""
		password:""
	}
	v.submit = ->
		id = (new Date).getTime()
		o = V.users_new.o.$model
		o.id = id
		o.power = 'user'
		console.log o
		$.post('/user/new',o, ()->
			console.log "new user"
			o.edit = 0
			V.users.users.unshift(o)
			V.users_new.o = {
                username: ''
                password: ''
            }
		)