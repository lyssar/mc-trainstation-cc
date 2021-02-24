--- @module server.service
local ServerService = {}

local Log = require("helper.log")
local ButtonApi = require("monitor.buttonApi")
local Settings = require("helper.settings")

-- local variables
local sLabel = nil

if "" ~= Settings:get("lystrain.server.label", "")
then
    sLabel = Settings:get("lystrain.server.label", "")
end

function ServerService:choseLabel()
    local chosenLabel = ""
    repeat
        Log:cmd("Enter a server label [%s]:", sLabel)
        term.write("[>] ")
        chosenLabel = read()
        if chosenLabel == "" and sLabel ~= ""
        then
            chosenLabel = sLabel
        end
    until (chosenLabel ~= "")

    if chosenLabel ~= "" then
        Settings:add("lystrain.server.label", chosenLabel);
        sLabel = chosenLabel
    end
end

function ServerService:initObserver()
    local ctrlKey = false
    Log:info("Start event observing [ctrl+c to terminate]")
    while true do
        local event, p1,p2,p3 = os.pullEvent()
        -- Monitor Observer
        if event == "monitor_touch" then
            ButtonApi:checkxy(p2,p3)
        end

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
        end
    end
end

function ServerService:setServerLabel()
    Log:info("Set server label to %s", sLabel)
    os.setComputerLabel(sLabel)
end

setmetatable(ServerService, {
    __call = function()
        local self = {}
        setmetatable(self, { __index = ServerService })
        return self
    end
})

return ServerService