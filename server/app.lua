--- @module server.app
local ServerApp = {}

local Settings = require("helper.settings")
local Log = require("helper.log")
local Modem = require("modem.service")
local Monitor = require("monitor.service")
local Station = require("monitor.station")
local Server = require("server.service")

local args = {...}

function ServerApp:run()

    Modem:setNs('server')

    if args[1] == "channels"
    then
        Modem:chosePosition()
        Modem:checkChannels()
        return
    elseif args[1] == "shutdown"
    then
        Modem:chosePosition()
        Modem:detach()
        return
    elseif args[1] == "observe"
    then
        Modem:reloadPosition()
        Monitor:reloadPosition()
        Station:setMonitor(Monitor:getMonitor())
        Station:render()
        Server:initObserver()
        return
    end

    Log:cmd("Starting train station server")

    -- Get needed information from User
    Server:choseLabel()
    Modem:chosePosition()
    Monitor:chosePosition()

    -- Save Settings after getting relevant user input
    Settings:save()

    -- Set server label
    Server:setServerLabel()

    -- Initial Modems
    Modem:registerChannels('server')

    -- Render Station
    Station:setMonitor(Monitor:getMonitor())
    Station:render()
    Log:cmd("Server is running. Please configure your clients")
    Server:initObserver()
end

setmetatable(ServerApp, {
    __call = function()
        local self = {}
        setmetatable(self, { __index = ServerApp })
        return self
    end
})

return ServerApp;