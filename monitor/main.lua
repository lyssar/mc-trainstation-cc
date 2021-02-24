require "_helper"
local log = require "_logger"
local settingsHelper = require "_settings"
local monitor = {} -- Namespace
local possibleDirections = {'top', 'left', 'right', 'back'}
local default = "back"
local chosenPosition = settingsHelper.get("lystrain.monitor.position", default)
local userInputReaded = 0
local activeMonitor


local function readUserInput()
    repeat
        if (userInputReaded == 1)
        then
            print("")
            log.error("Enter a correct monitor position [%s]:", chosenPosition)
        else
            print("")
            log.cmd("Enter monitor position [%s]:", chosenPosition)
        end

        term.write("[>] ")
        chosenPosition = read()
        userInputReaded = 1
    until(trim(chosenPosition) == "" or has_value(possibleDirections, chosenPosition))

    if(trim(chosenPosition) == "")
    then
        chosenPosition = settingsHelper.get("lystrain.monitor.position", default)
    end

    settingsHelper.add("lystrain.monitor.position", chosenPosition)
end

function monitor.chosePosition()
    repeat
        if userInputReaded == 1
        then
            userInputReaded = 0
            print("")
            log.error("Make sure that a monitor is present in '%s' position", chosenPosition)
        end

        readUserInput()
        userInputReaded = 1
    until (peripheral.isPresent(chosenPosition) == true and peripheral.getType(chosenPosition) == "monitor")
end

function monitor.getChosenPosition()
    monitor.reloadPosition()
    return chosenPosition
end 

function monitor.reloadPosition()
    if chosenPosition == nil
    then
        chosenPosition = settingsHelper.get("lystrain.monitor.position")
    end
end

function monitor.getMonitor()
    return peripheral.wrap(chosenPosition)
end

return monitor