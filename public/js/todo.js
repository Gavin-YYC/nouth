var TodoApp;
 
Storage.prototype.setObj = function(key, obj) {
      return localStorage.setItem(key, JSON.stringify(obj));

};
 
Storage.prototype.getObj = function(key) {
      return JSON.parse(this.getItem(key));

};
 
TodoApp = (function() {
    function TodoApp() {
            this.cacheElements();
                this.bindEvents();
                    this.displayItems();
                      
    }
     
    TodoApp.prototype.cacheElements = function() {
            this.$input = $('#new-todo');
                this.$todoList = $('#todo-list');
                    return this.$clearCompleted = $('#clear-completed');
                      
    };
     
    TodoApp.prototype.bindEvents = function() {
        this.$input.on('keyup', (function(_this) {
            return function(e) {
                        return _this.create(e);
                              
            };
                
        })(this));
        this.$todoList.on('click', '.destroy', (function(_this) {
            return function(e) {
                        return _this.destroy(e.target);
                              
            };
                
        })(this));
        this.$todoList.on('change', '.toggle', (function(_this) {
            return function(e) {
                        return _this.toggle(e.target);
                              
            };
                
        })(this));
        return this.$clearCompleted.on('click', (function(_this) {
            return function(e) {
                        return _this.clearCompleted();
                              
            };
                
        })(this));
          
    };
     
    TodoApp.prototype.create = function(e) {
            var randomId, val;
                val = $.trim(this.$input.val());
                if (!(e.which === 13 && val)) {
                          return;
                              
                }
                    randomId = Math.floor(Math.random() * 999999);
                    localStorage.setObj(randomId, {
                              id: randomId,
                              title: val,
                              completed: false
                            
                    });
                        this.$input.val('');
                            return this.displayItems();
                              
    };
     
    TodoApp.prototype.displayItems = function() {
            var id, _i, _len, _ref, _results;
                this.clearItems();
                    _ref = Object.keys(localStorage);
                        _results = [];
                        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                                  id = _ref[_i];
                                        _results.push(this.addItem(localStorage.getObj(id)));
                                            
                        }
                            return _results;
                              
    };
     
    TodoApp.prototype.clearItems = function() {
            return this.$todoList.empty();
              
    };
     
    TodoApp.prototype.addItem = function(item) {
            var html;
                html = "<li " + (item.completed ? 'class="completed"' : '') + " data-id=\"" + item.id + "\">\n        <div class=\"view\">\n            <input class=\"toggle\" type=\"checkbox\" " + (item.completed ? 'checked' : '') + ">\n            <label>" + item.title + "</label>\n            <button class=\"destroy\">Done</button>\n        </div>\n    </li>";
                    return this.$todoList.append(html);
                      
    };
     
    TodoApp.prototype.destroy = function(elem) {
            var id;
                id = ($(elem).closest('li')).data('id');
                    localStorage.removeItem(id);
                        return this.displayItems();
                          
    };
     
    TodoApp.prototype.toggle = function(elem) {
            var id, item;
                id = $(elem).closest('li').data('id');
                    item = localStorage.getObj(id);
                        item.completed = !item.completed;
                            return localStorage.setObj(id, item);
                              
    };
     
    TodoApp.prototype.clearCompleted = function() {
            return this.displayItems();
              
    };
     
      return TodoApp;
       

})();
 
$(function() {
      var app;
        return app = new TodoApp();
});
