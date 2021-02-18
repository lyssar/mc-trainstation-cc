require "_helper"
settingsHelper = require "_settings"
settingsHelper.load()

local log = require "_logger"
local modem = require "modem/index"
local monitor = require "monitor/index"
local server = require "server/index"

args = {...}


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
end

log.info("Starting train station server")

-- Get needed information from User
server.choseLabel()
modem.chosePosition()
monitor.chosePosition()

-- Save Settings after getting relevant user input
settingsHelper.save()

-- Set server label
server.setServerLabel()

-- Initial Modems
modem.registerChannels()

log.info("Server is running. Please configure your clients")