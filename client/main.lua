require "_helper"
local log = require "_logger"
local client = {...}
local sLabel = nil
local settingsHelper = require "_settings"
local _ns = nil

function client.choseLabel()
    local chosenLabel = ""

    if sLabel == nil and "" ~= settingsHelper.get("lystrain." .. _ns .. ".client.label", "")
    then
        sLabel = settingsHelper.get("lystrain." .. _ns .. ".client.label", "")
    end

    repeat
        log.cmd("Enter a client label [%s]:", sLabel)
        term.write("[>] ")
        chosenLabel = read()
        if chosenLabel == "" and sLabel ~= ""
        then
            chosenLabel = sLabel
        end
    until (chosenLabel ~= "")

    if chosenLabel ~= "" then
        settingsHelper.add("lystrain." .. _ns .. ".client.label", chosenLabel);
        sLabel = chosenLabel
    end
end

function client.setClientLabel()
    log.info("Set client label to %s", sLabel)
    os.setComputerLabel(sLabel)
end

function client.setNs(ns)
    _ns = ns
end


return client