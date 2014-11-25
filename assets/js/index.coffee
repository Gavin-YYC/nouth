#首页发布信息对话框
$('.ui.modal.post').modal('attach events','#post-new-btn','show')
$('.pgwSlider').pgwSlider();

avalon.define "posts",(v)->
    v.posts = posts

avalon.define "post_new",(v)->
    v.o = {
        category:''
        title:''
        content:''
        }
    v.options = categories
        #["家教", "艺术老师", "促销/导购", "传单派发", "问卷调查", "校园代理", "服务员", "钟点工", "礼仪/模特", "外卖送餐", "技工", "收银员", "翻译", "网站建设", "美工/设计", "网站编辑", "其他兼职"]
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
    false
