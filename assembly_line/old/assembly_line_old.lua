local os = require("os")
local robot = require("robot")
local comp = require("component")
local inv = comp.inventory_controller
local tank = comp.tank_controller
local sides = require("sides")
local invsize = 27
local linearsize = 10    

local recepie = {}

motor_01_luv = {}
motor_01_luv[1] = {"gt.metaitem.02.22356.name", 1, "solid"}
motor_01_luv[2] = {"gt.metaitem.02.22372.name", 2, "solid"}
motor_01_luv[3] = {"gt.metaitem.02.19345.name", 64, "solid"}
motor_01_luv[4] = {"gt.metaitem.02.19345.name", 64, "solid"}
motor_01_luv[5] = {"gt.metaitem.02.19345.name", 64, "solid"}
motor_01_luv[6] = {"gt.metaitem.02.19345.name", 64, "solid"}
motor_01_luv[7] = {"gt.blockmachines.cable.yttriumbariumcuprate.01.name", 2, "solid"}
motor_01_luv[8] = {"fluid.molten.solderingalloy", 144, "fluid"}
motor_01_luv[9] = {"fluid.lubricant", 250, "fluid"}

piston_01_luv = {}
piston_01_luv[1] = {"gt.metaitem.01.32606.name", 1, "solid", "piston_02_luv"}
piston_01_luv[2] = {"gt.metaitem.01.17372.name", 6, "solid"}
piston_01_luv[3] = {"gt.metaitem.01.28372.name", 4, "solid"}
piston_01_luv[4] = {"gt.metaitem.01.25372.name", 32, "solid"}
piston_01_luv[5] = {"gt.metaitem.01.23372.name", 4, "solid"}
piston_01_luv[6] = {"gt.metaitem.02.31372.name", 1, "solid"}
piston_01_luv[7] = {"gt.metaitem.02.20372.name", 2, "solid"}
piston_01_luv[8] = {"gt.blockmachines.cable.yttriumbariumcuprate.01.name", 4, "solid"}
piston_01_luv[9] = {"fluid.molten.solderingalloy", 144, "fluid"}
piston_01_luv[10] = {"fluid.lubricant", 250, "fluid"}

emitter_01_luv = {}
emitter_01_luv[1] = {"gt.blockmachines.gt_frame_hssg.name", 1, "solid", "emitter_02_luv"}
emitter_01_luv[2] = {"gt.metaitem.01.32684.name", 1, "solid"}
emitter_01_luv[3] = {"gt.metaitem.01.32683.name", 2, "solid"}
emitter_01_luv[4] = {"gt.metaitem.01.32682.name", 4, "solid"}
emitter_01_luv[5] = {"gt.metaitem.03.32085.name", 7, "solid"}
emitter_01_luv[6] = {"gt.metaitem.01.29303.name", 64, "solid"}
emitter_01_luv[7] = {"gt.metaitem.01.29303.name", 64, "solid"}
emitter_01_luv[8] = {"gt.metaitem.01.29303.name", 64, "solid"}
emitter_01_luv[9] = {"gt.blockmachines.cable.yttriumbariumcuprate.01.name", 7, "solid"}
emitter_01_luv[10] = {"fluid.molten.solderingalloy", 576, "fluid"}

plate_VIII_01 = {}
plate_VIII_01[1] = {"gt.metaitem.03.32006.name", 1, "solid", "plate_VIII_02"}
plate_VIII_01[2] = {"gt.metaitem.03.32073.name", 8, "solid"}
plate_VIII_01[3] = {"gt.metaitem.03.32012.name", 8, "solid"}
plate_VIII_01[4] = {"gt.blockmachines.gt_pipe_plastic_tiny.name", 4, "solid"}
plate_VIII_01[5] = {"Gold Item Casing", 8, "solid"}
plate_VIII_01[6] = {"gt.metaitem.01.29471.name", 64, "solid"}
plate_VIII_01[7] = {"gt.metaitem.01.17306.name", 4, "solid"}
plate_VIII_01[8] = {"fluid.growthmediumsterilized", 250, "fluid"}
plate_VIII_01[9] = {"UU-Matter", 100, "fluid"}
plate_VIII_01[10] = {"IC2 Coolant", 1000, "fluid"}

conveyor_01_luv = {}
conveyor_01_luv[1] = {"gt.metaitem.01.32606.name", 2, "solid"}
conveyor_01_luv[2] = {"gt.metaitem.01.17372.name", 2, "solid"}
conveyor_01_luv[3] = {"gt.metaitem.01.28372.name", 4, "solid"}
conveyor_01_luv[4] = {"gt.metaitem.01.25372.name", 32, "solid"}
conveyor_01_luv[5] = {"gt.blockmachines.cable.yttriumbariumcuprate.01.name", 2, "solid"}
conveyor_01_luv[6] = {"fluid.molten.styrenebutadienerubber", 1440, "fluid"}
conveyor_01_luv[7] = {"fluid.lubricant", 250, "fluid"}

recepie = {["motor_01_luv"] = motor_01_luv ,
           ["piston_01_luv"] = piston_01_luv ,
           ["emitter_01_luv"] = emitter_01_luv,
           ["plate_VIII_01"] = plate_VIII_01,
           ["conveyor_01_luv"] = conveyor_01_luv,
           ["motor_01_zpm"] = motor_01_zpm}

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
    robot.select(robot.select()   1)
    return true
  else
    os.sleep(0.1)
    inv.dropIntoSlot(sides.top, 1, robot.count())
    tmp = robot.count() - count
    robot.select(robot.select()   1)
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
        tmp = tmp   1
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
    fluid_start = fluid_start   1
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
  for i = 1, linearsize 1, 1 do
    robot.forward()
  end
  robot.up()
  while true do
    if(inv.suckFromSlot(sides.top, 4)) then
      break
    end
  end
  robot.down()
  for i = 1, linearsize 1, 1 do
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