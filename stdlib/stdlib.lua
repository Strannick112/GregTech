local Object = {} -- Базовый объект, от коготорого будем всё наследовать

function Object:new()
    local obj= {}
    setmetatable(obj, self)
    self.__index = self; return obj
end

local function extended (parent)
    local child = {}
    setmetatable(child,{__index = parent})
    return child
end

local function class ()
    return extended(Object)
end

local function parent(child)
    return getmetatable(child).__index
end



local stdlib = {}
stdlib.Object = Object
stdlib.extended=extended
stdlib.class=class
stdlib.parent=parent
stdlib.print=print
return stdlib