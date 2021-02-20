require "_helper"
local log = require "_logger"
local settingsHelper = require "_settings"
local buttonApi = require('monitor/buttonApi')
local modem = {} -- Namespace
local possibleDirections = {'top', 'left', 'right', 'back'}
local default = "back"
local chosenPosition = nil
local userInputReaded = 0
local activeModem
local _ns


local function readUserInput()
    repeat
        if (userInputReaded == 1)
        then
            print("")
            log.error("Enter a correct sender modem position [%s]:", chosenPosition)
        else 
            chosenPosition = settingsHelper.get("lystrain." .. _ns .. ".modem.position", default)
            print("")
            log.cmd("Enter sender modem position [%s]:", chosenPosition)
        end
        
        term.write("[>] ")
        chosenPosition = read()
        userInputReaded = 1
    until(trim(chosenPosition) == "" or has_value(possibleDirections, chosenPosition))

    if(trim(chosenPosition) == "")
    then
        chosenPosition = settingsHelper.get("lystrain." .. _ns .. ".modem.position", default)
    end

    settingsHelper.add("lystrain." .. _ns .. ".modem.position", chosenPosition)
end

function modem.chosePosition()
    repeat
        if userInputReaded == 1
        then
            userInputReaded = 0
            print("")
            log.error("Make sure that a modem is present in '%s' position", chosenPosition)
        end

        readUserInput(ns)
        userInputReaded = 1
    until (peripheral.isPresent(chosenPosition) == true and peripheral.getType(chosenPosition) == "modem")
end

function modem.getChosenPosition()
    modem.reloadPosition()
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
        log.cmd("Channel %d open? %s", channelId, activeModem.isOpen(channelId))
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

function modem.resetSignals()
    log.debug("reset signals")
    buttonApi.resetButtons()
    log.info("Transmit reset signal to clients")
    modem.getModem().transmit(1, 2, {rest=true})
end

function modem.sendSignal(type)
    log.debug("send a signal")
    log.info("Transmit dispatch signal to clients")
    modem.getModem().transmit(1, 2, {dispatch=type})
end

function modem.reloadPosition()
    if chosenPosition == nil
    then
        chosenPosition = settingsHelper.get("lystrain." .. _ns .. ".modem.position")
    end
end

function modem.setNs(ns)
    _ns = ns
end

function modem.getModem()
    return peripheral.wrap(modem.getChosenPosition())
end

return modem