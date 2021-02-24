--- @module client.service
local ClientService = {}

local Settings = require("helper.settings")
local Log = require("helper.log")
local sLabel = nil
local _ns = nil

function ClientService:choseLabel()
    local chosenLabel = ""

    if sLabel == nil and "" ~= Settings:get("lystrain." .. _ns .. ".client.label", "")
    then
        sLabel = Settings:get("lystrain." .. _ns .. ".client.label", "")
    end

    repeat
        Log:cmd("Enter a client label [%s]:", sLabel)
        term.write("[>] ")
        chosenLabel = read()
        if chosenLabel == "" and sLabel ~= ""
        then
            chosenLabel = sLabel
        end
    until (chosenLabel ~= "")

    if chosenLabel ~= "" then
        Settings:add("lystrain." .. _ns .. ".client.label", chosenLabel);
        sLabel = chosenLabel
    end
end

function ClientService:setClientLabel()
    Log:info("Set client label to %s", sLabel)
    os.setComputerLabel(sLabel)
end

function ClientService:setNs(ns)
    _ns = ns
end

setmetatable(ClientService, {
    __call = function()
        local self = {}
        setmetatable(self, { __index = ClientService })
        return self
    end
})

return ClientService