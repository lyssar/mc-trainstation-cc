-- make sure that the json api is present and loaded
shell.execute("pastebin get 4nRg9CHU json")
os.loadAPI("json")

-- create the lystrain directory
if fs.isDir("lystrain") == false
then
    os.execute("mkdir lystrain")
end

-- Make a request against the git repo
local request = http.get("https://api.github.com/repos/lyssar/mc-trainstation-cc/git/trees/master?recursive=1")
local contents = json.decode(request.readAll())

request.close()

-- TODO: Download needed file into the created folder