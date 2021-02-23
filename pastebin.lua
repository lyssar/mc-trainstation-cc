require "_helper"
local gistID = "a67defc89b42f1dd4bbde07d9f5c000b"
local gistFileName = "installer.lua"

local function get(paste)
    write( "Connecting to gist.github.com... " )
    local response = http.get(
        "https://gist.github.com/lyssar/"..textutils.urlEncode( paste ) .. "/raw/" .. gistFileName
    )

    if response then
        print( "Success." )

        local sResponse = response.readAll()
        response.close()
        return sResponse
    else
        print( "Failed." )
    end
end

local res = get(gistID)
if res then
    local func, err = load(res, gistID, "t", _ENV)
    if not func then
        printError( err )
        return
    end

    local success, msg = pcall(func)
    if not success then
        printError( msg )
    end
end
