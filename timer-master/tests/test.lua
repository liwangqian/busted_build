#!/usr/bin/env lua
local tm = require "timer"

print "sleeping xx ms..."
local x = tm.gettime()
tm.msleep(1000)
print(math.floor((tm.gettime() - x) * 1000))
print "done."
