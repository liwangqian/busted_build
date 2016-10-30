--[[

Shows how to define a callback to be invoked as soon as an option is parsed.
Callbacks are useful for abruptive options like "--help" or "--version" where
you might want to stop the execution of the parser/program if passed.

Try this file with the following commands lines;
  example.lua --version
  example.lua -v
  example.lua
--]]

local cli = require "cliargs"

-- this is called when the flag -v or --version is set
local function print_version()
  print(cli.name .. ": version 1.2.1")
  os.exit(0)
end

cli:set_name("try_my_version.lua")
cli:flag("-v, --version", "prints the program's version and exits", print_version)

-- Parses from _G['arg']
local args, err = cli:parse()

-- something wrong happened, we print the error and exit
if not args then
  print(err)
  os.exit(1)
end

-- if we got to this point, it means -v (or --version) were not passed:
print "Why, hi!"
