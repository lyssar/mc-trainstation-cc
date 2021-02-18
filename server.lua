require "_helper"
modem = require "_modem"
args = {...}

local possibleDirections = {'top', 'left', 'right', 'back'}

if args[1] == "channels"
then
    modem.chosePosition()
    modem.checkChannels()
    return
elseif args[1] == "shutdown"
then
    modem.chosePosition()
    modem.detach()
    return
end

log.info("Starting train station server")

modem.chosePosition()

-- Initial Modems
modem.registerChannels()

log.info("> Server is running. Please configure your clients")