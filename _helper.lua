log = {};

function trim(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function printf(...)
    print(string.format(...))
end

function has_value (tab, val)
    for index, tabName in ipairs(tab) do
        if tabName == val then
            return true
        end
    end

    return false
end

function log.msg(msg, type)
    local color = colors.blue
    local prefix = "[INFO]";

    if type == "error"
    then 
        prefix = "[ERROR]"
        color = colors.red
    elseif type == "notice"
    then
        color = colors.yellow
        prefix = "[NOTICE]"
    end

    term.setTextColor(color)
    term.write(prefix)
    term.setTextColor(colors.white)
    printf(" - %s", msg)
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