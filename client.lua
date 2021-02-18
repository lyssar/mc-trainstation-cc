require "_helper"
settingsHelper = require "_settings"
settingsHelper.load()


local log = require "_logger"
local modem = require "modem/main"
local client = require "client/main"


log.info("Starting train station client")

-- Get needed information from User
client.setNs('client' .. os.computerID())
client.choseLabel()

modem.setNs('client' .. os.computerID())
modem.chosePosition()

-- Save Settings after getting relevant user input
settingsHelper.save()

-- Set client label
client.setClientLabel()

-- Initial Modems
modem.registerChannels()

log.info("Client is ready to recieve data.")
