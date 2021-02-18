require "_helper"
local log = require "_logger"
local settingsHelper = {...}
local data = nil
local loaded = false
local settingsHelperIni = script_path() .. "settings.ini"

function settingsHelper.load()
    if loaded == true
    then
        log.notice("Configuration settomgs already loaded: %s", loaded)
        return
    end

    if fs.exists(settingsHelperIni) == false
    then
        log.info("Create  settingsHelper.ini")
    end

    log.info("Loading settings")
    loaded = true
    settings.load(settingsHelperIni)
end

function settingsHelper.save()
    if loaded == false
    then
        log.notice("Settings not loader. Skip saving")
        return
    end

    log.notice("Saving settings")

    settings.save(settingsHelperIni)
end

function settingsHelper.get(key, default)
    if loaded == false then settingsHelper.load(); end
    if default == nil then default = ""; end
    
    return settings.get(key, default) 
end

function settingsHelper.add(key, val)
    settings.set(key, val) 
end

return settingsHelper