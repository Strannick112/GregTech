local rc = require("utilities/recepies")
local itemsInfo = require("utilities/itemsInfo").itemsInfo
local twire = require "twire/twire"
local ser = require("serialization")

twire.describe('recepies tests', function()

    twire.it('test_create_recepie', function()
        obj = rc.recepie:new("name",{})
        twire.assert.notNull(obj)
    end)

    twire.it('test_create_not_empty_recepie', function()
        local items = {}
        table.insert(items, itemsInfo:new("name1", "label1"))
        table.insert(items, itemsInfo:new("name2", "label2"))
        table.insert(items, itemsInfo:new("name3", "label3"))
        table.insert(items, itemsInfo:new("name4", "label4"))

        obj = rc.recepie:new("name",items)
        twire.assert.notNull(obj)
        twire.assert.equals(obj.name,"name")
        twire.assert.equals(ser.serialize(items),ser.serialize(obj.recepies))
    end)

end)