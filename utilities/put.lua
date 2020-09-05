local comp = require("component")
local internet = require("internet")
local fs = require("filesystem")

local file_name = "put.lua"
local file = io.open("/home/"..file_name, "r")
local tmp = file:read("*a")
file:close()
internet.request("http://oc.regela.ru/upload.php", {filename = file_name, file = tmp})