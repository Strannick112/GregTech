local twire = require "twire/twire"
local std = require "stdlib/stdlib"

twire.describe('stdlib tests', function()

    twire.it('test_create_object', function()
        obj = std.Object:new()
        twire.assert.notNull(obj)
    end);

    twire.it('test_extend_object', function()
        local child = std.extended(std.Object)
        local child_obj = child:new()
        twire.assert.notNull(child)
        twire.assert.notNull(child_obj)
    end);

    twire.it('test_user_class', function()
        class = std.class()

        twire.assert.notNull(class)

        function class:new(param)
            local obj = std.parent(self):new();
            obj.param = param or "test"
            function obj:getParam()
                return self.param
            end
            return obj
        end

        local obj = class:new()

        twire.assert.notNull(obj)

        twire.assert.equals(obj:getParam() ,"test")

        obj = class:new("new_test")

        twire.assert.notNull(obj)

        twire.assert.equals(obj:getParam() ,"new_test")
    end);

    twire.it('test_user_classes_extend', function()
        local parent_class = std.class()

        twire.assert.notNull(parent_class)

        function parent_class:new(param)
            local parent = std.parent(self)
            local obj = parent:new();
            obj.parent_param = param or "test"
            function obj:getParam()
                return self.parent_param
            end
            function obj:getParentParam()
                return self.parent_param
            end
            function obj:getParentParamForReassign()
                return self.parent_param
            end
            return obj
        end

        local obj = parent_class:new()

        twire.assert.notNull(obj)

        twire.assert.equals(obj:getParam() ,"test")
        twire.assert.equals(obj:getParentParam() ,"test")

        local child_class = std.extended(parent_class)

        function child_class:new(param)
            local parent = std.parent(self)
            local obj = parent:new(param);
            obj.child_param = param or "test_child"
            function obj:getParam()
                return self.child_param
            end
            obj.__getParentParamForReassign = obj.getParentParamForReassign
            function obj:getParentParamForReassign()
                return "child: "..self:__getParentParamForReassign()
            end
            return obj
        end

        local child_obj = child_class:new()
        twire.assert.notNull(child_obj)

        twire.assert.equals(child_obj:getParam() ,"test_child")
        twire.assert.equals(child_obj:getParentParam() ,"test")
        twire.assert.equals(child_obj:getParentParamForReassign() ,"child: test")

        local child_obj_2 = child_class:new("param")
        twire.assert.notNull(child_obj_2)

        twire.assert.equals(child_obj_2:getParam() ,"param")
        twire.assert.equals(child_obj_2:getParentParam() ,"param")
    end);
end);