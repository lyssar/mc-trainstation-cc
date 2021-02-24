-- make sure that the json api is present and loaded
shell.execute("pastebin get 4nRg9CHU json")
os.loadAPI("json")
local prjdir = "test"

-- create the lystrain directory
if fs.isDir(prjdir) == false
then
    os.execute("mkdir " .. prjdir)
end

-- Make a request against the git repo
local request = http.get("https://api.github.com/repos/lyssar/mc-trainstation-cc/git/trees/master?recursive=1")
local contents = json.decode(request.readAll())

request.close()

for i, file in pairs(contents.tree) do
    if (
        (
            string.find(file.path, ".lua") ~= nil
            or string.find(file.path, "monitor") ~= nil
            or string.find(file.path, "modem") ~= nil
            or string.find(file.path, "server") ~= nil
            or string.find(file.path, "client") ~= nil
        )
        and string.find(file.path, "installer") == nil
        and string.find(file.path, "pastebin") == nil
    ) then
        if string.find(file.path, ".lua") then
            local fileRequest = http.get(file.url)
            print(prjdir .. "/" .. file.path)
            local fileIo = io.open(prjdir .. "/" .. file.path, "w")
            io.output(fileIo)
            io.write(textutils.serialize(file))
            io.close(fileIo)

            -- local fileContent = fileRequest.getAll()
            -- fileRequest.close()

            -- local fileIo = io.open (file.path, "w")
            -- io.output(fileIo)
            -- io.write(fileContent)
            -- io.close(fileIo)
        else
            if fs.isDir(prjdir .. "/" .. file.path) == false
            then
                os.execute("mkdir " .. prjdir .. "/" .. file.path)
            end
        end
    end
end

-- TODO: Download needed file into the created folder