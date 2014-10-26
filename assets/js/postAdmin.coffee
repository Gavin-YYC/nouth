avalon.define "posts", (v) ->

    for i in posts
        i.edit = 0

    v.options = categories

    v.posts = posts

    v.getCate = (cid)->
            for v,i in categories
                console.log cid
                console.log v.id
                if v.id == cid+''
                     return categories[i].name
 
    v.origin = {}
    v.edit = (o)->
        v.origin = o
        o.edit = !o.edit

    v.remove = (rm,o) ->
        rm()
        $.post('/post/remove',{id:o.id}, ()->
            console.log 'a post removed'
        )

    v.cancel = (o)->
        o.edit = !o.edit
        $.extend(o,v.origin)

    v.submit =(o) ->
        console.log o.id
        new_o = new Object()
        new_o.id = o.id
        new_o.category = o.category
        new_o.title = o.title
        new_o.content = o.content
        o.edit = !o.edit
        $.post('/post/update',new_o, ()->
            console.log 'a post updated'
        )

