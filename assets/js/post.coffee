avalon.define "posts", (v) ->
    v.posts = posts
    v.remove = (rm,o) ->
        rm()
        $.post('/post/remove',{id:o.id}, ()->
            console.log 'a post removed'
        )
