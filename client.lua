require "_helper.lua"
settingsHelper = require "_settings.lua"
settingsHelper.load()


local log = require "_logger.lua"
local modem = require "modem/main.lua"
local client = require "client/main.lua"


log.cmd("Starting train station client")

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

log.cmd("Client is ready to recieve data.")
