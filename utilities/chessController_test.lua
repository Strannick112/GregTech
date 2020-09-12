local itemsInfo = require("utilities/itemsInfo").itemsInfo
local twire = require "twire/twire"
local chestController = require("utilities/chestController").chestController
local ser = require("serialization")

twire.describe('chestController tests', function()

    twire.it('test_create_chestController', function()
        local obj = chestController:new()
        twire.assert.notNull(obj)
    end)

end)