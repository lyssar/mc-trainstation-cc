--- @module helper.settings
local Settings = {}

local Helper = require("helper.service")
local Log = require("helper.log")
local loaded = false
local SettingsCacheFile = Helper:script_path() .. "settings.cache"

function Settings:load()
    if loaded == true
    then
        Log:notice("Configuration settomgs already loaded: %s", loaded)
        return
    end

    if fs.exists(SettingsCacheFile) == false
    then
        Log:info("Create settings cache file")
    end

    Log:info("Loading settings")
    loaded = true
    settings.load(SettingsCacheFile)
end

function Settings:save()
    if loaded == false
    then
        Log:notice("Settings not loader. Skip saving")
        return
    end

    Log:notice("Saving settings")

    settings.save(SettingsCacheFile)
end

function Settings:get(key, default)
    if loaded == false then Settings:load(); end
    if default == nil then default = ""; end

    return settings.get(key, default)
end

function Settings:add(key, val)
    settings.set(key, val)
end

setmetatable(Settings, {
    __call = function()
        local self = {}
        setmetatable(self, { __index = Settings })
        return self
    end
})

return Settings;
