#首页发布信息对话框
$('.ui.modal.post').modal('attach events','#post-new-btn','show')

avalon.define "posts",(v)->
    v.posts = posts

avalon.define "post_new",(v)->
    v.o = {
        title:''
        content:''
        }
    v.submit = ->
        $.post('/post/new',V.post_new.o.$model, () ->
            o = V.post_new.o.$model
            V.posts.posts.unshift(o)
            V.post_new.o = {
                title:''
                conent:''
                }
       )
    false
