local config = require("config")
local log = {...}

local logLvl = {
    cmd = -1,
    off = 0,
    error = 10,
    notice = 20,
    info = 30,
    debug = 40,
    all = 50
}

function log.msg(msg, type)
    local color = colors.blue
    local prefix = "[INFO]";
    local allowedLogLevel = logLvl[config.LOG_LEVEL]
    local givenLogLevel = logLvl[type]

    if givenLogLevel == nil or allowedLogLevel < givenLogLevel
    then
        return
    end

    if type == "error"
    then 
        prefix = "[ERROR]"
        color = colors.red
    elseif type == "notice"
    then
        color = colors.yellow
        prefix = "[NOTICE]"
    elseif type == "cmd"
    then
        color = colors.white
        prefix = "[>]"
    end

    term.setTextColor(color)
    term.write(prefix)
    term.setTextColor(colors.white)
    printf(" %s", msg)
end

function log.info(...)
    local msg = string.format(...)
    log.msg(msg, 'info')
end

function log.error(...)
    local msg = string.format(...)
    log.msg(msg, 'error')
end

function log.notice(...)
    local msg = string.format(...)
    log.msg(msg, 'notice')
end

function log.cmd(...)
    local msg = string.format(...)
    log.msg(msg, 'cmd')
end

return log