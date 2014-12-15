avalon.define "posts", (v) ->
    v.posts = posts
    v.categories = categories
    v.show = ""
    v.showCateLast = (o) -> 
        v.show =""
        $.post('/category/categoryLast',{cateClass:o},(data)->
            for i in data
            	v.show +='<li><a href="?cid='+i.id+'">'+i.name+'</a></li>'
        )