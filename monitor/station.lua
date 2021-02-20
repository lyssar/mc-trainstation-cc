local buttonApi = require('monitor/buttonApi')
local modem = require('modem/main')
local settingsHelper = require "_settings"
local log = require "_logger"
local station = {...}
local _monitor
local offset = 2
local headlineHeight = 2
local maxPerRow = 3
local buttons = config.stations

function station.render()
    buttonApi.setMonitor(_monitor)
    buttonApi.prepareMonitor(_monitor)
    buttonApi.heading(settingsHelper.get("lystrain.server.label", ""), offset)

    local buttonAmount = table.getn(buttons)
    local panWidth, panHeight = _monitor.getSize()
    local innerPanWidth = panWidth - ((maxPerRow + 1) * offset)
    local buttonWidth = innerPanWidth / maxPerRow
    local buttonHeight = (panHeight / (buttonAmount / maxPerRow)) - (offset * 2)

    if buttonHeight > 5 then buttonHeight = 5; end

    local leftStart = offset
    local leftStop = leftStart + buttonWidth
    local topStart = offset + headlineHeight
    local topStop = topStart + buttonHeight


    -- while true do
    for index, buttonData in pairs(buttons) do
        buttonApi.setTable(
            buttonData['name'],
            buttonData['station_label'],
            handleStationChange,
            buttonData,
            math.floor(leftStart),
            math.floor(leftStop),
            math.floor(topStart),
            math.floor(topStop)
        )

        if math.fmod(index, maxPerRow) == 0 then topStart = topStart + buttonHeight + offset; end
        leftStart = leftStop + offset
        leftStop = leftStart + buttonWidth
        topStop = topStart + buttonHeight
    end

    buttonApi.screen()
end

function handleStationChange(buttonInfo)
    log.debug("station change emitted")
    modem.resetSignals()
    -- station.sendSignal(buttonInfo.dispatcher)
    buttonApi.setButton(buttonInfo.name, true)
    modem.sendSignal(buttonInfo.dispatcher)
end

function station.observeMonitor()
    event, side, x, y = os.pullEvent("monitor_touch")
    buttonApi.checkxy(x, y)
end

function station.setMonitor(monitor)
    _monitor = monitor
end

return station