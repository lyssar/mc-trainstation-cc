require "_helper"
local log = require "_logger"
local server = {...}
local sLabel = nil
local buttonApi = require('monitor/buttonApi')
local settingsHelper = require "_settings"

if "" ~= settingsHelper.get("lystrain.server.label", "")
then
    sLabel = settingsHelper.get("lystrain.server.label", "")
end

function server.choseLabel()
    local chosenLabel = ""
    repeat
        log.cmd("Enter a server label [%s]:", sLabel)
        term.write("[>] ")
        chosenLabel = read()
        if chosenLabel == "" and sLabel ~= ""
        then
            chosenLabel = sLabel
        end
    until (chosenLabel ~= "")

    if chosenLabel ~= "" then
        settingsHelper.add("lystrain.server.label", chosenLabel);
        sLabel = chosenLabel
    end
end

function server.initObserver()
    local ctrlKey = false
    log.info("Start event observing [ctrl+c to terminate]")
    while true do
        local event, p1,p2,p3 = os.pullEvent()
        -- Monitor Observer
        if event == "monitor_touch" then
            buttonApi.checkxy(p2,p3)
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
                buttonApi.clearTable()
                log.info("Stop event observing. To start again call `server observe`")
                return;
            end
        end
    end
end

function server.setServerLabel()
    log.info("Set server label to %s", sLabel)
    os.setComputerLabel(sLabel)
end

return server