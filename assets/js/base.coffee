#首页发布信息对话框
$('.ui.modal.post').modal('attach events','#post-new-btn','show')

# 下拉菜单
$('.ui.dropdown').dropdown();

V = avalon.vmodels

avalon.define 'user', (v)->
    v.user = user

avalon.define "post_new",(v)->
    v.o = {
        category:''
        title:''
        content:''
    }
    v.show = ""
    v.submit = ->
        $.post('/post/new',V.post_new.o.$model, () ->
            o = V.post_new.o.$model
            V.posts.posts.unshift(o)
            V.post_new.o = {
                category:''
                title:''
                content:''
                }
       )
    v.showCateLast = (o)->
        v.cateClass = "1"
        $.post('/category/categoryLast',{cateClass:o},(data)->
            
        )