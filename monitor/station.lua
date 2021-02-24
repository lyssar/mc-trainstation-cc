--- @module monitor.station
local StationService = {}

local ButtonApi = require("monitor.buttonApi")
local ModemService = require("modem.service")
local Settings = require("helper.settings")
local Log = require("helper.log")
local _monitor
local offset = 2
local headlineHeight = 2
local maxPerRow = 3
local buttons = config.stations

local function handleStationChange(buttonInfo)
    Log:debug("station change emitted")
    ModemService:resetSignals()
    -- StationService:sendSignal(buttonInfo.dispatcher)
    ButtonApi:setButton(buttonInfo.name, true)
    ModemService:sendSignal(buttonInfo.dispatcher)
end

function StationService:render()
    ButtonApi:setMonitor(_monitor)
    ButtonApi:prepareMonitor(_monitor)
    ButtonApi:heading(Settings:get("lystrain.server.label", ""), offset)

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
        ButtonApi:setTable(
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

    ButtonApi:screen()
end

function StationService:observeMonitor()
    event, side, x, y = os.pullEvent("monitor_touch")
    ButtonApi:checkxy(x, y)
end

function StationService:setMonitor(monitor)
    _monitor = monitor
end

setmetatable(StationService, {
    __call = function()
        local self = {}
        setmetatable(self, { __index = StationService })
        return self
    end
})

return StationService