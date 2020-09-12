local std = require("stdlib/stdlib")
local ser = require("serialization")
local itemsInfo = require("utilities/itemsInfo").itemsInfo
local recepie = std.class()

function recepie:new(name, items)
    local obj = std.parent(self):new()
    obj.name = name or "unkown"
    obj.recepies = items or {}

    function obj:getRecepies()
       return self.recepies
    end

    function obj:addItem(item)
        table.insert(self.recepies, item)
    end

    function obj:contains(items, onlySolid)
        local neededItems = {}
        for k, v in pairs(self.recepies) do
            if not onlySolid or v.type == "solid" then
                neededItems[v.label] = neededItems[v.label] or 0 + v.count
            end
        end
        for k, v in pairs(items) do
            if(neededItems[v.label] ~= nil) then
                neededItems[v.label] = neededItems[v.label] - v.count
            end
        end
        for k, v in pairs(neededItems) do
            if v > 0 then return false end
        end
        return true
    end

    function obj:readFromFile(io, filePath)
        local file = io.open(filePath, "r")
        local fileData = file:read("*a")
        file:close()
        local rawItems = ser.unserialize(fileData)
        for k,v in pars(rawItems) do
            self.obj:addItem(itemsInfo:new(v.name, v.label, v.count, v.type))
        end
    end

    function obj:writeToFile(io, filePath)
        local file = io.open(filePath, "w")
        if file == nil then return "OpenFileError" end
        file:write(ser.serialize(self.recepies))
    end

    return obj
end

return {
    recepie = recepie
}
