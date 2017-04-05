--[[

    PigBot Services
  DiscordService ver 0.1.0
  Responsible for all communications regarding Discord

  Change Log:
    [452017a]
      - Initial publication


Help us improve PigBot Services! Contribute to our source at our public GitHub:
https://github.com/DBReinitialized/PigBot
]]

local discordService = {}
PigBot.DiscordService = discordService

-- Load Dependancies
local dependancies = {}
dependancies.SessionsManager = PigBot.RobloxLibraries.SessionsManager
dependancies.Discordia = require("Discordia")
discordService.dependancies = dependancies

-- Setup Discordia connections
local clients = {}
local clientSettings = {
  fetchMembers = true,
  largeThreshold = 200
}
clients.UserBotClient             = dependancies.Discordia.Client(clientSettings)
clients.UserAccountClient         = dependancies.Discordia.Client(clientSettings)
discordService.clients = clients

clients.UserBotClient:on(
  "ready",
  function()
    print(">> Successfully logged in as", clients.UserBotClient.user.username)
  end
)
clients.UserAccountClient:on(
  "ready",
  function()
    print(">> Successfully logged in as", clients.UserAccountClient.user.username)
  end
)

-- Load Modules
require("./Modules/CommandsService.lua")
