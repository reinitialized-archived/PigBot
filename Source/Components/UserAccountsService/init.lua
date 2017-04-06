--[[

    PigBot Services
  UserAccountsService ver 0.1.0
  Responsible for the management of internal UserAccounts and their data.

  Change Log:
    [452017a]
      - Initial publication


Help us improve PigBot Services! Contribute to our source at our public GitHub:
https://github.com/DBReinitialized/PigBot
]]

local userAccountsService = {}
PigBot.UserAccountsService = UserAccountsService

local dependancies = {}
dependancies.DataService = PigBot.DataService
dependancies.RobloxLibraries = PigBot.RobloxLibraries
userAccountService.dependancies = dependancies

local database = PigBot.DataService.createDatabase("UserAccountService")
local storedAccounts = {}


-- main API
local MemberJoinedServerSignal = dependancies.RobloxLibraries.LuaSignal.new()
local MemberLeftServerSignal = dependancies.RobloxLibraries.LuaSignals.new()

MemberJoinedServerSignal.
