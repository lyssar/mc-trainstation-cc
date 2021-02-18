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
    repeat
        log.cmd("Enter a server label [%s]:", sLabel)
        sLabel = read()
    until (sLabel ~= nil)

    if sLabel ~= "" then settingsHelper.add("lystrain.server.label", sLabel); end
end

function server.setServerLabel()
    log.info("Set server label to %s", sLabel)
    os.setComputerLabel(sLabel)
end

return server