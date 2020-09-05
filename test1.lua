local robot = require("robot")
local sides = require("sides")
local io = require("io")
local fs = require("filesystem")
local comp = require("component")
local ser = require("serialization")
local inv = comp.inventory_controller

local linear_test = {}

function linear_test.check(file_name)
  local list = {}
  local file = fs.open("/home/linear_recepies/" .. file_name, "w")
  print(file)
  if(file) then print("файл создался"); else print("файл не создался"); end
  for i = 1, inv.getInventorySize(sides.top), 1 do
    if(inv.getStackInSlot(sides.top, i) ~= nil) then
      print(inv.getStackInSlot(sides.top, i).label, inv.getStackInSlot(sides.top, i).size)
      list[i] = {inv.getStackInSlot(sides.top, i).label, inv.getStackInSlot(sides.top, i).size, "solid"}
      print(list[i])
    end
  end
  local tmp = ser.serialize(list)
  file:write(tmp)
  print(tmp)
  --file:flush()
  file:close()
end

return linear_test