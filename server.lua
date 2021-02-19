require "_helper"
settingsHelper = require "_settings"
settingsHelper.load()

local log = require "_logger"
local modem = require "modem/main"
local monitor = require "monitor/main"
local station = require "monitor/station"
local server = require "server/main"

args = {...}

modem.setNs('server')

if args[1] == "channels"
then
    modem.chosePosition()
    modem.checkChannels()
    return
elseif args[1] == "shutdown"
then
    modem.chosePosition()
    modem.detach()
    return
elseif args[1] == "observe"
then
    modem.reloadPosition()
    monitor.reloadPosition()
    station.setMonitor(monitor.getMonitor())
    station.render()
    server.initObserver()
    return
end

log.cmd("Starting train station server")

-- Get needed information from User
server.choseLabel()
modem.chosePosition()
monitor.chosePosition()

-- Save Settings after getting relevant user input
settingsHelper.save()

-- Set server label
server.setServerLabel()

-- Initial Modems
modem.registerChannels('server')

-- Render Station
station.setMonitor(monitor.getMonitor())
station.render()
log.cmd("Server is running. Please configure your clients")
server.initObserver()