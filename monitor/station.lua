local buttonApi = require('monitor/buttonApi')
local settingsHelper = require "_settings"
local station = {...}
local _monitor
local offset = 2
local headlineHeight = 2
local maxPerRow = 3
local buttons = {
    {
        name="sven",
        dispatcher="to_sven",
        station_label="Sven"
    },
    {
        name="timo",
        dispatcher="to_timo",
        station_label="Timo"
    },
    {
        name="kathrin",
        dispatcher="to_kathrin",
        station_label="Kathrin"
    }
}

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
        buttonApi.setTable(buttonData['station_label'], handleStationChange, buttonData, math.floor(leftStart), math.floor(leftStop), math.floor(topStart), math.floor(topStop))

        if math.fmod(index, maxPerRow) == 0 then topStart = topStart + buttonHeight + offset; end
        leftStart = leftStop + offset
        leftStop = leftStart + buttonWidth
        topStop = topStart + buttonHeight
    end

    buttonApi.screen()
end

function handleStationChange(buttonInfo)
    print('Called')
    printt(buttonInfo)
end

function station.observeMonitor()
    while true do
        event, side, x, y = os.pullEvent("monitor_touch")
        buttonApi.checkxy(x, y)
    end
end

function station.setMonitor(monitor)
    _monitor = monitor
end

return station