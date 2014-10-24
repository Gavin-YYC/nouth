$('.ui.modal.category').modal('attach events','#category-new-btn','show')

avalon.define "category_new", (v)->
    v.o = {
        name: ''
    }
    v.submit = ->
        id = (new Date).getTime()
        o = V.category_new.o.$model
        o.id = id
        console.log o.name
        console.log o
        $.post('/category/new',o, ()->
            console.log 'new category'
            o.edit = 0
            V.categories.categories.unshift(o)
            V.category_new.o = {
                name: ''
            }
        )

avalon.define "categories", (v) ->

    for i in categories
        i.edit = 0

    v.categories = categories

    v.origin = {}
    v.edit = (o)->
        v.origin = o
        o.edit = !o.edit

    v.remove = (rm,o) ->
        rm()
        $.post('/category/remove',{id:o.id}, ()->
            console.log 'a category removed'
        )

    v.cancel = (o)->
        o.edit = !o.edit
        $.extend(o,v.origin)

    v.submit =(o) ->
        console.log 'submit'+o.id
        o.edit = !o.edit
        $.post('/category/update',{id:o.id,name:o.name}, ()->
            console.log 'a category updated'
        )

