--[[

    PigBot Services
  PigBotServer ver 0.1.0
  Main component responsible for setting up and initializing PigBot

  Change Log:
    [452017a]
      - Initial publication


Help us improve PigBot Services! Contribute to our source at our public GitHub:
https://github.com/DBReinitialized/PigBot
]]

local PigBot = {}
_G.PigBot = PigBot

-- Load Components
require("./Settings.lua")
require("./Components/RobloxLibraries")
require("./Components/DataService")
require("./Components/DiscordService")

-- Initialize Services
PigBot.DiscordService.clients.UserBotClient:run(PigBot.Settings.DiscordService.UserBotLogin)
PigBot.DiscordService.clients.UserAccountClient:run(PigBot.Settings.DiscordService.UserAccountLogin[1], PigBot.Settings.DiscordService.UserAccountLogin[2])

-- Pass control to the Scheduler
PigBot.RobloxLibraries.Scheduler.startService()
