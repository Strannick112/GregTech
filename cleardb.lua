local comp = require("component")
local db = comp.database

for i = 1, 81, 1 do
  db.clear(i)
end