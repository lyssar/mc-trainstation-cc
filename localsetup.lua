--- @module localsetup
local LocalSetup = {}

local Helper = require("helper.service")


function LocalSetup:run()
    if(os.getComputerID() == 0)
    then
        os.setComputerLabel("Server01")
        periphemu.create("top", "modem", "dispatcher01")
        periphemu.create(1, "computer", "client01")
        periphemu.create(2, "computer", "client02")
        periphemu.create("left", "monitor", "monitor01")
        print(Helper:script_path() .. "run server")
        shell.execute(Helper:script_path() .. "run server")
    elseif os.getComputerID() > 0
    then
        os.setComputerLabel("Client " .. os.getComputerID())
        periphemu.create("right", "modem", "reciever" .. os.getComputerID())

        local client = require "client.app"
        client:run()
    end
end

setmetatable(LocalSetup, {
    __call = function()
        local self = {}
        setmetatable(self, { __index = LocalSetup })
        return self
    end
})

return LocalSetup