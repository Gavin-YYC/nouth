$('.ui.modal.category').modal('attach events','#category-new-btn','show')

avalon.define "category_new", (v)->
    v.o = {
        name: ''
    }
    v.cateClass = "1"
    v.submit = ->
        id = (new Date).getTime()
        o = V.category_new.o.$model
        o.id = id
        o.cateClass = v.cateClass
        console.log(o.cateClass)
        $.post('/category/new',o, ()->
            o.edit = 0
            V.category_new.o = {
                name: ''
            }
        )

avalon.define "categories", (v) ->

    for i in categories
        i.edit = 0

    v.categories = categories

    v.origin = {}
    v.show = "二级标题"
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

    v.showCateLast = (o)->
        v.show =""
        $.post('/category/categoryLast',{cateClass:o.id},(data)->
            for i in data
                v.show += i.name
                console.log i
        )
