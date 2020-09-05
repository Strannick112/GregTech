local fs = require("filesystem")
local ser = require("serialization")
--local io = require("io")
local file = io.open("linear_recepies/motor_01_zpm", "r")

local tmp = file:read("*a")
file:close()
local tmp2 = ser.unserialize(tmp)

print(tmp)
print("--------")
for k, v in pairs(tmp2) do
  for key, value in pairs(v) do
    print(key, value)
  end
end