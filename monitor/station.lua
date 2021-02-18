local station = {...}
local _monitor

function station.render()
    _monitor.clear()
    _monitor.setCursorPos( 1, 1 )
    local width, height = _monitor.getSize()
    print("width: " .. width .. " height: " .. height)
end

function station.setMonitor(monitor)
    _monitor = monitor
end

return station