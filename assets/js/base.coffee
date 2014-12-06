#首页发布信息对话框
$('.ui.modal.post').modal('attach events','#post-new-btn','show')

V = avalon.vmodels

avalon.define 'user', (v)->
    v.user = user
