avalon.define "posts", (v) ->
    for i in posts
        i.edit = 0

    v.posts = posts

    v.edit = (o)->
        o.edit = !o.edit

    v.remove = (rm,o) ->
        rm()
        $.post('/post/remove',{id:o.id}, ()->
            console.log 'a post removed'
        )

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

