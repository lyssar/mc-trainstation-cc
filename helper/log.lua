--- @module helper.log
local Log = {}

local Helper = require("helper.service")
local Config = require("config")

local logLvl = {
    cmd = -1,
    off = 0,
    error = 10,
    notice = 20,
    info = 30,
    debug = 40,
    all = 50
}

function Log:msg(msg, type)
    local color = colors.blue
    local prefix = "[INFO]";
    local allowedLogLevel = logLvl[Config.LOG_LEVEL]
    local givenLogLevel = logLvl[type]

    if givenLogLevel == nil or allowedLogLevel < givenLogLevel
    then
        return
    end

    if type == "error"
    then
        prefix = "[ERROR]"
        color = colors.red
    elseif type == "Helpernotice"
    then
        color = colors.yellow
        prefix = "[NOTICE]"
    elseif type == "debug"
    then
        color = colors.gray
        prefix = "[DEBUG]"
    elseif type == "cmd"
    then
        color = colors.white
        prefix = "[>]"
    end

    term.setTextColor(color)
    term.write(prefix)
    term.setTextColor(colors.white)
    Helper:printf(" %s", msg)
end

function Log:info(...)
    local msg = string.format(...)
    Log:msg(msg, 'info')
end

function Log:error(...)
    local msg = string.format(...)
    Log:msg(msg, 'error')
end

function Log:notice(...)
    local msg = string.format(...)
    Log:msg(msg, 'notice')
end

function Log:cmd(...)
    local msg = string.format(...)
    Log:msg(msg, 'cmd')
end

function Log:debug(...)
    local msg = string.format(...)
    Log:msg(msg, 'debug')
end

setmetatable(Log, {
    __call = function()
        local self = {}
        setmetatable(self, { __index = Log })
        return self
    end
})

return Log;
