--- @module monitor.service
local MonitorService = {}

local Helper = require("helper.service")
local Log = require("helper.log")
local Settings = require("helper.settings")
local possibleDirections = {'top', 'left', 'right', 'back'}
local default = "back"
local chosenPosition = Settings:get("lystrain.monitor.position", default)
local userInputReaded = 0
local monitor


local function readUserInput()
    repeat
        if (userInputReaded == 1)
        then
            print("")
            Log:error("Enter a correct monitor position [%s]:", chosenPosition)
        else 
            print("")
            Log:cmd("Enter monitor position [%s]:", chosenPosition)
        end

        term.write("[>] ")
        chosenPosition = read()
        userInputReaded = 1
    until(Helper:trim(chosenPosition) == "" or Helper:has_value(possibleDirections, chosenPosition))

    if(Helper:trim(chosenPosition) == "")
    then
        chosenPosition = Settings:get("lystrain.monitor.position", default)
    end

    Settings:add("lystrain.monitor.position", chosenPosition)
end

function MonitorService:chosePosition()
    repeat
        if userInputReaded == 1
        then
            userInputReaded = 0
            print("")
            Log:error("Make sure that a monitor is present in '%s' position", chosenPosition)
        end

        readUserInput()
        userInputReaded = 1
    until (peripheral.isPresent(chosenPosition) == true and peripheral.getType(chosenPosition) == "monitor")
end

function MonitorService:getChosenPosition()
    MonitorService:reloadPosition()
    return chosenPosition
end 

function MonitorService:reloadPosition()
    if chosenPosition == nil
    then
        chosenPosition = Settings:get("lystrain.monitor.position")
    end
end

function MonitorService:getMonitor()
    return peripheral.wrap(chosenPosition)
end

setmetatable(MonitorService, {
    __call = function()
       local self = {}
       setmetatable(self, { __index = MonitorService })
       return self
    end
})

return MonitorService