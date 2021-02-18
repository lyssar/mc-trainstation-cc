require "_helper"
local log = require "_logger"
local settingsHelper = require "_settings"
local modem = {} -- Namespace
local possibleDirections = {'top', 'left', 'right', 'back'}
local default = "back"
local chosenPosition = settingsHelper.get("lystrain.modem.position", default)
local userInputReaded = 0
local activeModem


local function readUserInput()
    repeat
        if (userInputReaded == 1)
        then
            print("")
            log.error("Enter a correct sender modem position [%s]:", chosenPosition)
        else 
            print("")
            log.info("Enter sender modem position [%s]:", chosenPosition)
        end
        chosenPosition = read()
        userInputReaded = 1
    until(trim(chosenPosition) == "" or has_value(possibleDirections, chosenPosition))

    if(trim(chosenPosition) == "")
    then
        chosenPosition = settingsHelper.get("lystrain.modem.position", default)
    end

    settingsHelper.add("lystrain.modem.position", chosenPosition)
end

function modem.chosePosition()
    repeat
        if userInputReaded == 1
        then
            userInputReaded = 0
            print("")
            log.error("Make sure that a modem is present in '%s' position", chosenPosition)
        end

        readUserInput()
        userInputReaded = 1
    until (peripheral.isPresent(chosenPosition) == true and peripheral.getType(chosenPosition) == "modem")
end

function modem.getChosenPosition()
    return chosenPosition
end

function modem.registerChannels()
    log.info("Register channels")
    activeModem = peripheral.wrap(chosenPosition)
    
    for channelId = 1, 3 do
        if activeModem.isOpen(channelId) == false
        then
            activeModem.open(channelId)
            log.info("Channel registered %d", channelId)
        end
    end
end

function modem.checkChannels()
    shell.execute("clear")
    log.info("Check channels")
    activeModem = peripheral.wrap(chosenPosition)
    
    for channelId = 1, 3 do
        log.info("Channel %d open? %s", channelId, activeModem.isOpen(channelId))
    end
end

function modem.detachChannels()
    activeModem = peripheral.wrap(chosenPosition)
    log.notice("Detach channels")

    activeModem.closeAll()
end

function modem.detach()
    activeModem = peripheral.wrap(chosenPosition)
    modem.detachChannels()
    log.notice("Detach modem from %s", chosenPosition)
    activeModem = nil
    chosenPosition = default
end

return modem