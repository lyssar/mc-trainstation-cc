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

function explode(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

function printt(t, s)
    for k, v in pairs(t) do
        local kfmt = '["' .. tostring(k) ..'"]'
        if type(k) ~= 'string' then
            kfmt = '[' .. k .. ']'
        end
        local vfmt = '"'.. tostring(v) ..'"'
        if type(v) == 'table' then
            printt(v, (s or '')..kfmt)
        else
            if type(v) ~= 'string' then
                vfmt = tostring(v)
            end
            print(type(t)..(s or '')..kfmt..' = '..vfmt)
        end
    end
end

function script_path()
    local str = shell.getRunningProgram()
    return str:match("(.*/)")
 end