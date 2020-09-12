require "lunit/lunit"
local std = require "stdlib/stdlib"
module( "stdlib_tests", lunit.testcase )

function test_create_object()
    obj = std.Object:new()
    lunit.assert_not_nil(obj)
end

function test_extend_object()
    local child = std.extended(std.Object)
    local child_obj = child:new()
    lunit.assert_not_nil(child)
    lunit.assert_not_nil(child_obj)
end

function test_user_class()
    class = std.class()

    assert_not_nil(class)

    function class:new(param)
        local obj = std.parentNew(self);
            obj.param = param or "test"
        function obj:getParam()
            return self.param
        end
        return obj
    end

    local obj = class:new()

    assert_not_nil(obj)

    assert_equal(obj:getParam() ,"test")

    obj = class:new("new_test")

    assert_not_nil(obj)

    assert_equal(obj:getParam() ,"new_test")
end


function test_user_class()
    class = std.class()

    assert_not_nil(class)

    function class:new(param)
        local obj = std.parent(self):new(self);
        obj.param = param or "test"
        function obj:getParam()
            return self.param
        end
        return obj
    end

    local obj = class:new()

    assert_not_nil(obj)

    assert_equal(obj:getParam() ,"test")

    obj = class:new("new_test")

    assert_not_nil(obj)

    assert_equal(obj:getParam() ,"new_test")
end

function test_user_classes_extend()
    local parent_class = std.class()

    assert_not_nil(parent_class)

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

    assert_not_nil(obj)

    assert_equal(obj:getParam() ,"test")
    assert_equal(obj:getParentParam() ,"test")

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
    assert_not_nil(child_obj)

    assert_equal(child_obj:getParam() ,"test_child")
    assert_equal(child_obj:getParentParam() ,"test")
    assert_equal(child_obj:getParentParamForReassign() ,"child: test")

    local child_obj_2 = child_class:new("param")
    assert_not_nil(child_obj_2)

    assert_equal(child_obj_2:getParam() ,"param")
    assert_equal(child_obj_2:getParentParam() ,"param")

end



lunit.main(...)