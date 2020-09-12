local robot = require("robot")
local sides = require("sides")
local io = require("io")
local fs = require("filesystem")
local comp = require("component")
local ser = require("serialization")
local inv = comp.inventory_controller

local assembly_line = {}

function assembly_line.check(file_name, ...)
  --local args_i = 1
  local list = {}
  local file = fs.open("/usr/bin/assembly_line/recepies/" .. file_name, "w")
  print(file)
  if(file) then print("файл создался"); else print("файл не создался"); end
  for i = 1, inv.getInventorySize(sides.top), 1 do
    if(inv.getStackInSlot(sides.top, i) ~= nil) then
      print(inv.getStackInSlot(sides.top, i).label, inv.getStackInSlot(sides.top, i).size)
      --if(inv.getStackInSlot(sides.top, i).name == "extracells:certustank") then
        --list[i] = {string.sub(inv.getStackInSlot(sides.top, i).label, 22, string.len(inv.getStackInSlot(sides.top, i).label)), arg[args_i] or -1, "fluid"}
        --args_i = args_i + 1
      --else
        list[i] = {inv.getStackInSlot(sides.top, i).label, inv.getStackInSlot(sides.top, i).size, "solid"}
      --end
      print(list[i])
    end
  end
  local tmp = ser.serialize(list)
  file:write(tmp)
  print(tmp)
  file:close()
end

return assembly_line