local std = require "stdlib/stdlib"
local itemsInfo = require("utilities/itemsInfo").itemsInfo
local chessController = std.class()

function chessController:new()
    local obj = std.parent(self):new()

    function obj:clearCache()
        self.slots = {}
        self.emptySlots = {}
        self.items = {}
        self.itemsCount = 0
        self.fullSlotsCount = 0
    end

    function obj:readChessIC(side, ic)
        self.obj:clearCache()
        for i = 1, ic.getInventorySize(side), 1 do
            local item = ic.getStackInSlot(side, i)
            if(item ~= nil) then
                 -- name, label, count, type
                local ii = itemsInfo:new(item.name, item.label, item.size)
                self.fullSlotsCount = self.fullSlotsCount + 1
                self.itemsCount = self.itemsCount + ii.count
                self.slots[i] = ii
                self.items[ii.name].size = (self.items[ii.name].size or 0) + ii.count
            else
                table.insert(self.emptySlots,i)
            end
        end
    end

    obj:obj:clearCache()

    return obj
end

return {
    chessController = chessController
}