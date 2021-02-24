--- @module lystrain
local Log = require("helper.log")

local Settings = require("helper.settings")
Settings:load()

local commands = {}
commands.localsetup = require "localsetup"
commands.client = require "client.app"
commands.server = require "server.app"

local subcommand = arg[1]

local usage = [[
Usage: run server|client [ARGUMENT]
Example: run server
Transforms text through various filters, must be used via stdin.
Options:
  -h, --help  Display this help
Available commands:
  server   Starting the train station server
  client   Starting a client
  help     display the help]]

if not subcommand or subcommand == '--help' or subcommand == '-h' or subcommand == 'help' then
    return print(usage)
end

Log:cmd("Run command %s", subcommand)

if commands[subcommand] then
    commands[subcommand].run()
else
    Log:error("Command not found %s", subcommand)
end