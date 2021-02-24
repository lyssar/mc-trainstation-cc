--- @module client.app
local ClientApp = {}

local Settings = require("helper.settings")
local Log = require("helper.log")
local ModemService = require("modem.service")
local ClientService = require("client.service")

local args = {...}

function ClientApp:run()
    Log:cmd("Starting train station client")
    -- Get needed information from User
    ClientService:setNs('client' .. os.computerID())
    ClientService:choseLabel()

    ModemService:setNs('client' .. os.computerID())
    ModemService:chosePosition()
    -- Save Settings after getting relevant user input
    Settings:save()
    -- Set client label
    ClientService:setClientLabel()
    -- Initial Modems
    ModemService:registerChannels()

    Log:cmd("Client is ready to recieve data.")
end

setmetatable(ClientApp, {
    __call = function()
        local self = {}
        setmetatable(self, { __index = ClientApp })
        return self
    end
})

return ClientApp;
