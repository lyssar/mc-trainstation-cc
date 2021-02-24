--- @module helper.service
local HelperService = {}

function HelperService:trim(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function HelperService:printf(...)
    print(string.format(...))
end

function HelperService:has_value (tab, val)
    for index, tabName in ipairs(tab) do
        if tabName == val then
            return true
        end
    end

    return false
end

function HelperService:explode(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

function HelperService:printt(t, s)
    for k, v in pairs(t) do
        local kfmt = '["' .. tostring(k) ..'"]'
        if type(k) ~= 'string' then
            kfmt = '[' .. k .. ']'
        end
        local vfmt = '"'.. tostring(v) ..'"'
        if type(v) == 'table' then
            HelperService:printt(v, (s or '')..kfmt)
        else
            if type(v) ~= 'string' then
                vfmt = tostring(v)
            end
            print(type(t)..(s or '')..kfmt..' = '..vfmt)
        end
    end
end

function HelperService:script_path()
    local str = shell.getRunningProgram()
    return str:match("(.*/)")
end

setmetatable(HelperService, {
    __call = function()
        local self = {}
        setmetatable(self, { __index = HelperService })
        return self
    end
})

return HelperService;
