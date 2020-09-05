local robot = require("robot")
local sides = require("sides")
local io = require("io")
local fs = require("filesystem")
local comp = require("component")
local inv = comp.inventory_controller

local linear = {}

function linear.check(file_name)
  local file = fs.open("/home/linear_recepies/" .. file_name, "w")
  print(file)
  if(file) then print("файл создался"); else print("файл не создался"); end
  file:write("local " .. file_name .. " = {} \n\n")
  for i = 1, inv.getInventorySize(sides.top), 1 do
    if(inv.getStackInSlot(sides.top, i) ~= nil) then
      print(inv.getStackInSlot(sides.top, i).label, inv.getStackInSlot(sides.top, i).size)
      local flag = file:write(file_name .. '[' .. i .. '] = {"' .. inv.getStackInSlot(sides.top, i).label .. '", ' .. inv.getStackInSlot(sides.top, i).size .. ', "solid"}\n')
      if(flag) then print("запись совершена"); else print("ошибка записи"); end
    end
  end
  --file:flush()
  file:close()
end

return linear