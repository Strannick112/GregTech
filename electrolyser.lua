local comp = require("component")
local os = require("os")
local db = comp.database
local me_controller = comp.me_controller
local export_bus = comp.me_exportbus
local db_size

while true do
  db_size = 1
  local me = nil
  repeat
    me = me_controller.getItemsInNetwork()
  until(type(me) ~= "nil")
  if(type(me) ~= "nil") then
    for k, v in ipairs(me) do
      local tmp
      repeat
        tmp = me_controller.store(me[db_size], db.address, db_size, db_size)
      until(tmp)
      if(tmp) then
        if(db.get(db_size) ~= nil) then
          db_size = db_size   1
        else
          db_size = db_size - 1
        end
      end
    end
    db_size = db_size - 1
    local min = 100000000
    local min_label = "jerk"
    for k, v in ipairs(me) do
      if(v.size <= min) then
        min = v.size
        min_label = v.label
      end
    end
    print("--------")
    for i = 1, db_size, 1 do
      if(db.get(i).label == min_label) then
        print("Сейчас обрабатывается: ", min_label)
        print("В сети его сейчас: ", min)
        export_bus.setExportConfiguration(2, 1, db.address, i)
      end
    end
    for i = 1, db_size, 1 do
      db.clear(i)
    end
  end
  os.sleep(1)
end