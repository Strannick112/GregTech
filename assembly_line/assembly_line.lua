local os = require("os")
local robot = require("robot")
local comp = require("component")
local inv = comp.inventory_controller
local tank = comp.tank_controller
local sides = require("sides")
local invsize = 27
local linearsize = 10
local fs = require("filesystem")
local ser = require("serialization")
--local io = require("io")


local recepie = {}

for file_name in filesystem.list("/usr/bin/assembly_line/recepies") do

	local file = io.open("/usr/bin/assembly_line/recepies/"..file_name, "r")
	local tmp = file:read("*a")
	file:close()
	local tmp2 = ser.unserialize(tmp)

	--print(tmp)
	--print("--------")
	--for k, v in pairs(tmp2) do
  		--for key, value in pairs(v) do
    		--print(key, value)
  		--end
	--end	
	table.insert(recepie, {[file_name] = file})
end


function check()
  if inv.getStackInSlot(sides.top, 1) then
    return false
  else
    return true 
  end
end

function check_input()
  local flag_inside = false
  local flag_outside = true
  for key, value in pairs(recepie) do
    flag_outside = true
    for k, v in pairs(value) do
      if (v[3] == "solid") then
        flag_inside = false
        for i = 1, invsize, 1 do
          if(inv.getStackInSlot(sides.top, i) ~= nil) then
            if(inv.getStackInSlot(sides.top, i).label == v[1]) then
              flag_inside = true
              break
            end
          end
        end
        if not flag_inside then 
          flag_outside = false 
          break 
        end
      end
    end
    if flag_outside then
      return key
    end
  end
  return "jerk"
end

function take_resources(craft)
  for key, value in pairs(recepie) do
    if(craft == key) then
      for k, v in pairs(value) do
        for i = 1, invsize, 1 do
          if(inv.getStackInSlot(sides.top, i) ~= nil ) then
            if(inv.getStackInSlot(sides.top, i).label == v[1]) then
              print(v[1])
              inv.suckFromSlot(sides.top, i, v[2])
            end
          end
        end
      end
    end
  end
  return true
end

function drop(count)
  local tmp = robot.count()
  if(inv.getStackInSlot(sides.top, 1) ~= nil ) then
    return false
  end
  if(tmp - count == 0) then
    os.sleep(0.1)
    inv.dropIntoSlot(sides.top, 1, tmp)
    robot.select(robot.select() + 1)
    return true
  else
    os.sleep(0.1)
    inv.dropIntoSlot(sides.top, 1, robot.count())
    tmp = robot.count() - count
    robot.select(robot.select() + 1)
    drop(robot.count())
  end
end

function give_resources(craft)
  robot.forward()
  robot.up()
  robot.select(1)
  for k, v in pairs(recepie[craft]) do
    if(v[3] == "solid") then
      print(v[2])
      drop(v[2])
      robot.forward()
    end
  end
  robot.select(1)
  robot.turnAround()
  for k, v in pairs(recepie[craft]) do
    if(v[3] == "solid") then
      robot.forward()
    end
  end
  robot.down()
  robot.forward()
  robot.turnAround()
  return true
end

function transfer_fluids(craft)
  robot.forward()
  robot.up()
  robot.turnRight()
  robot.forward()
  robot.turnLeft()
  local tmp = 0
  local fluid_start = 1
  local back_to_start_flug = false
  for k, v in pairs(recepie[craft]) do
    if(v[3] == "fluid") then
      if(not robot.detectDown()) then
        back_to_start_flug = true
        goto back_to_start
      end
      while(tank.getFluidInTank(sides.bottom)[1].label ~= v[1]) do
        print(tank.getFluidInTank(sides.bottom)[1].label, v[1])
        robot.forward()
        tmp = tmp + 1
        if(not robot.detectDown()) then
          back_to_start_flug = true
          goto back_to_start
        end
      end
      print(tmp)
      robot.drainDown(v[2])
      ::back_to_start::
      while(tmp ~= 0) do
        robot.back()
        tmp = tmp - 1
      end
      if back_to_start_flug then goto back_to_end end
      for i = 1, k - fluid_start, 1 do
        robot.forward()
      end
      robot.fillUp(v[2])
      for i = 1, k - fluid_start, 1 do
        robot.back()
      end
    else
    fluid_start = fluid_start + 1
    end
  end
  ::back_to_end::
  robot.turnLeft()
  robot.forward()
  robot.down()
  robot.turnRight()
  robot.back()
  return true
end

function finish(craft)
  for i = 1, linearsize + 1, 1 do
    robot.forward()
  end
  robot.up()
  while true do
    if(inv.suckFromSlot(sides.top, 4)) then
      break
    end
  end
  robot.down()
  for i = 1, linearsize + 1, 1 do
    robot.back()
  end
  robot.turnAround()
  for i = 1, invsize, 1 do
    if(inv.getStackInSlot(sides.front, i) ~= nil) then
      if(inv.getStackInSlot(sides.front, i).label == craft) then
        inv.suckFromSlot(sides.front, i)
        break
      end
    end 
  end
  if(recepie[craft][1][4] ~= nil ) then
    for i = 1, invsize, 1 do
      if(inv.getStackInSlot(sides.front, i) ~= nil) then
        if(inv.getStackInSlot(sides.front, i).label == recepie[craft][1][4]) then
          inv.suckFromSlot(sides.front, i)
          break
        end
      end
    end
  end
  robot.turnLeft()
  for i = 16, 1, -1 do
    if(inv.getStackInInternalSlot(i) ~= nil ) then
      robot.select(i)
      for j = 1, invsize, 1 do
        if(inv.getStackInSlot(sides.front, j) == nil ) then
          if(i == 1) then 
            os.sleep(1) 
          end
          inv.dropIntoSlot(sides.front, j)
        end
      end
    end
  end
  robot.turnLeft()
  robot.select(1)
  print("Craft succesfull!")
end

while true do
  print("it's start")
  while check() do
    print("waiting")
  end
  print("doing")
  craft = check_input()
  if (craft ~= "jerk") then
    print(craft)
    take_resources(craft)
    give_resources(craft)
    transfer_fluids(craft)
    finish(craft)
    print("doing")
  end
end