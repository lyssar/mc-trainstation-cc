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

function ClientService:initObserver()
    local ctrlKey = false
    Log:info("Start event observing [ctrl+c to terminate]")
    while true do
        local event, p1,p2,p3 = os.pullEvent()
        -- Monitor Observer

        -- kill observer ctrl+c handler
        if event == "key" or event == "key_up" then
            -- trag if ctrlKey is pressed
            if event == "key" and (p1 == 29 or p1 == 157) then ctrlKey = true; end
            -- trag if ctrlKey is released
            if event == "key_up" and (p1 == 29 or p1 == 157) then ctrlKey = false; end
            -- cancel oberserver on ctrl + c press            
            if event == "key" and p1 == 46 and ctrlKey == true then
                ctrlKey = false
                ButtonApi:clearTable()
                Log:info("Stop event observing. To start again call `server observe`")
                return;
            end
        else
            print(event)
        end
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