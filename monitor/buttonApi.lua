--- @module monitor.buttonApi
local ButtonApi = {}

local _monitor
local button={}
local Log = require("helper.log")

function ButtonApi:setMonitor(mon)
   Log:debug("set monitor")
    _monitor = mon
end

function ButtonApi:prepareMonitor()
   Log:debug("prepare monitor")
    _monitor.setTextScale(1)
    _monitor.setTextColor(colors.white)
    _monitor.setBackgroundColor(colors.black)
    ButtonApi:clearTable()
end

function ButtonApi:clearTable()
   Log:debug("clear monitor")
   button = {}
   _monitor.clear()
end

function ButtonApi:setButton(name, buttonOn)
   Log:debug("set button activity of %s to %s", name, buttonOn)
   button[name]["active"] = buttonOn
   ButtonApi:screen()
end

function ButtonApi:resetButtons()
   Log:debug("reset all buttons")
   for name, data in pairs(button) do
      button[name]["active"] = false
   end
   ButtonApi:screen()
end

function ButtonApi:setTable(name, label, func, param, xmin, xmax, ymin, ymax)
   Log:debug("Add button to table")
   button[name] = {}
   button[name]["func"] = func
   button[name]["label"] = label
   button[name]["active"] = false
   button[name]["param"] = param
   button[name]["xmin"] = xmin
   button[name]["ymin"] = ymin
   button[name]["xmax"] = xmax
   button[name]["ymax"] = ymax
end

local function fill(text, color, bData)
   Log:debug("Print button")
    _monitor.setBackgroundColor(color)
   local yspot = math.floor((bData["ymin"] + bData["ymax"]) /2)
   local xspot = math.floor((bData["xmax"] - bData["xmin"] - string.len(text)) /2) +1
   for j = bData["ymin"], bData["ymax"] do
    _monitor.setCursorPos(bData["xmin"], j)
      if j == yspot then
         for k = 0, bData["xmax"] - bData["xmin"] - string.len(text) +1 do
            if k == xspot then
                _monitor.write(text)
            else
                _monitor.write(" ")
            end
         end
      else
         for i = bData["xmin"], bData["xmax"] do
            _monitor.write(" ")
         end
      end
   end
   _monitor.setBackgroundColor(colors.black)
end

function ButtonApi:screen()
   Log:debug("rerender monitor")
   local currColor
   for name,data in pairs(button) do
      local on = data["active"]
      if on == true then currColor = colors.lime else currColor = colors.red end
      fill(data["label"], currColor, data)
   end
end

function ButtonApi:toggleButton(name)
   Log:debug("toggle button")
   button[name]["active"] = not button[name]["active"]
   ButtonApi:screen()
end     

function ButtonApi:flash(name)
   Log:debug("flash button")
   ButtonApi:toggleButton(name)
   ButtonApi:screen()
   sleep(0.15)
   ButtonApi:toggleButton(name)
   ButtonApi:screen()
end

function ButtonApi:checkxy(x, y)
   Log:debug("check monitor click position")
   for name, data in pairs(button) do
      if y>=data["ymin"] and  y <= data["ymax"] then
         if x>=data["xmin"] and x<= data["xmax"] then
            if data["param"] == "" then
              data["func"]()
            else
              data["func"](data["param"])
            end
            return true
            --data["active"] = not data["active"]
            --print(name)
         end
      end
   end
   return false
end

function ButtonApi:heading(text, topOffset)
   Log:debug("render heading")
   w, h = _monitor.getSize()
   _monitor.setCursorPos((w-string.len(text))/2+1, topOffset)
   _monitor.write(text)
end

function ButtonApi:label(w, h, text)
   Log:debug("render label")
   _monitor.setCursorPos(w, h)
   _monitor.write(text)
end

setmetatable(ButtonApi, {
   __call = function()
      local self = {}
      setmetatable(self, { __index = ButtonApi })
      return self
   end
})

return ButtonApi