--- @module modem.service
local ModemService = {}

local Helper = require("helper.service")
local Log = require("helper.log")
local Settings = require("helper.settings")
local ButtonApi = require("monitor.buttonApi")

local default = "back"
local chosenPosition = nil
local userInputReaded = 0
local possibleDirections = {'top', 'left', 'right', 'back'}
local modem
local _ns


local function readUserInput()
    repeat
        if (userInputReaded == 1)
        then
            print("")
            Log:error("Enter a correct sender modem position [%s]:", chosenPosition)
        else 
            chosenPosition = Settings:get("lystrain." .. _ns .. ".modem.position", default)
            print("")
            Log:cmd("Enter sender modem position [%s]:", chosenPosition)
        end
        
        term.write("[>] ")
        chosenPosition = read()
        userInputReaded = 1
    until(Helper:trim(chosenPosition) == "" or Helper:has_value(possibleDirections, chosenPosition))

    if(Helper:trim(chosenPosition) == "")
    then
        chosenPosition = Settings:get("lystrain." .. _ns .. ".modem.position", default)
    end

    Settings:add("lystrain." .. _ns .. ".modem.position", chosenPosition)
end

function ModemService:chosePosition()
    repeat
        if userInputReaded == 1
        then
            userInputReaded = 0
            print("")
            Log:error("Make sure that a modem is present in '%s' position", chosenPosition)
        end

        readUserInput(ns)
        userInputReaded = 1
    until (peripheral.isPresent(chosenPosition) == true and peripheral.getType(chosenPosition) == "modem")
end

function ModemService:getChosenPosition()
    ModemService:reloadPosition()
    return chosenPosition
end

function ModemService:registerChannels()
    Log:info("Register channels")
    modem = peripheral.wrap(chosenPosition)
    
    for channelId = 1, 3 do
        if modem.isOpen(channelId) == false
        then
            modem.open(channelId)
            Log:info("Channel registered %d", channelId)
        end
    end
end

function ModemService:checkChannels()
    shell.execute("clear")
    Log:info("Check channels")
    modem = peripheral.wrap(chosenPosition)
    
    for channelId = 1, 3 do
        Log:cmd("Channel %d open? %s", channelId, modem.isOpen(channelId))
    end
end

function ModemService:detachChannels()
    modem = peripheral.wrap(chosenPosition)
    Log:notice("Detach channels")

    modem.closeAll()
end

function ModemService:detach()
    modem = peripheral.wrap(chosenPosition)
    ModemService:detachChannels()
    Log:notice("Detach modem from %s", chosenPosition)
    modem = nil
    chosenPosition = default
end

function ModemService:resetSignals()
    Log:debug("reset signals")
    ButtonApi:resetButtons()
    Log:info("Transmit reset signal to clients")
    ModemService:getModem().transmit(1, 2, {rest=true})
end

function ModemService:sendSignal(type)
    Log:debug("send a signal")
    Log:info("Transmit dispatch signal to clients")
    ModemService:getModem().transmit(1, 2, {dispatch=type})
end

function ModemService:reloadPosition()
    if chosenPosition == nil
    then
        chosenPosition = Settings:get("lystrain." .. _ns .. ".modem.position")
    end
end

function ModemService:setNs(ns)
    _ns = ns
end

function ModemService:getModem()
    return peripheral.wrap(ModemService:getChosenPosition())
end


setmetatable(ModemService, {
    __call = function()
        local self = {}
        setmetatable(self, { __index = ModemService })
        return self
    end
})

return ModemService