local std = require "stdlib/stdlib"

local itemsInfo = std.class()

function itemsInfo:new(name, label, count, type)
    local obj = std.parent(self):new()
    obj.name = name or "unkown"
    obj.label = label or obj.name
    obj.count = count or 1
    obj.type = type or "solid"
    return obj
end

return {
    itemsInfo = itemsInfo,
}
