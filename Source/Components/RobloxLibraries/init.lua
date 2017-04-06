local RobloxLibraries = {}

RobloxLibraries.LuaSignals = require("./LuaSignals.lua")
RobloxLibraries.Scheduler = require("./Scheduler.lua")
RobloxLibraries.SessionsManager = require("./SessionsManager.lua")


-- Load Module into PigBot core
PigBot.RobloxLibraries = RobloxLibraries
