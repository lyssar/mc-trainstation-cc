require "_helper"
local log = require "_logger"
local server = {...}
local sLabel = nil
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

function server.setServerLabel()
    log.info("Set server label to %s", sLabel)
    os.setComputerLabel(sLabel)
end

return server