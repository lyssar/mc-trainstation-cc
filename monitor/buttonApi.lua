local buttonApi = {}
local _monitor
local button={}
local log = require "_logger"

function buttonApi.setMonitor(mon)
   log.debug("set monitor")
    _monitor = mon
end

function buttonApi.prepareMonitor()
   log.debug("prepare monitor")
    _monitor.setTextScale(1)
    _monitor.setTextColor(colors.white)
    _monitor.setBackgroundColor(colors.black)
    buttonApi.clearTable()
end

function buttonApi.clearTable()
   log.debug("clear monitor")
   button = {}
   _monitor.clear()
end

function buttonApi.setButton(name, buttonOn)
   log.debug("set button activity of %s to %s", name, buttonOn)
   button[name]["active"] = buttonOn
   buttonApi.screen()
end

function buttonApi.resetButtons()
   log.debug("reset all buttons")
   for name, data in pairs(button) do
      button[name]["active"] = false
   end
   buttonApi.screen()
end
                                             
function buttonApi.setTable(name, label, func, param, xmin, xmax, ymin, ymax)
   log.debug("Add button to table")
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

function fill(text, color, bData)
   log.debug("Print button")
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
     
function buttonApi.screen()
   log.debug("rerender monitor")
   local currColor
   for name,data in pairs(button) do
      local on = data["active"]
      if on == true then currColor = colors.lime else currColor = colors.red end
      fill(data["label"], currColor, data)
   end
end

function buttonApi.toggleButton(name)
   log.debug("toggle button")
   button[name]["active"] = not button[name]["active"]
   buttonApi.screen()
end     

function buttonApi.flash(name)
   log.debug("flash button")
   buttonApi.toggleButton(name)
   buttonApi.screen()
   sleep(0.15)
   buttonApi.toggleButton(name)
   buttonApi.screen()
end
                                             
function buttonApi.checkxy(x, y)
   log.debug("check monitor click position")
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
     
function buttonApi.heading(text, topOffset)
   log.debug("render heading")
   w, h = _monitor.getSize()
   _monitor.setCursorPos((w-string.len(text))/2+1, topOffset)
   _monitor.write(text)
end
     
function label(w, h, text)
   log.debug("render label")
   _monitor.setCursorPos(w, h)
   _monitor.write(text)
end

return buttonApi