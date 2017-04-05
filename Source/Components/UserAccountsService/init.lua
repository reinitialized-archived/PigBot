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
PigBot.UserAccountsService = UserAccountsService/i wan

local userDatabase = PigBot.DataService.createDatabase("UserAccountService")
local userAccounts = userDatabase.dumpDatabase()
