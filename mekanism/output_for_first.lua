local comp = require("component")
local os = require("os")
local db = comp.database
local me_controller = comp.me_controller
local export_bus = comp.me_exportbus

while true do
  local me = nil
  repeat
    me = me_controller.getItemsInNetwork()
  until(type(me) == "nil")
  if(#me ~= 0) then
    local tmp
    repeat
      tmp = me_controller.store(me[1], db.address, 1, 1)
    until(tmp)

    print("--------")
    print("Сейчас обрабатывается: ", min_label)
    print("В сети его сейчас: ", min)
    export_bus.setExportConfiguration(2, 1, db.address, 1)
    db.clear(1)
  else
    print("--------")
    print("Сейчас ничего обрабатывается: ", min_label)
    print("В сети его сейчас: IQ Разработчика", min)
  end
  os.sleep(1)
end