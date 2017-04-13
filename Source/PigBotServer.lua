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

-- load boilerplate code
require("BoilerUtilities.lua"):importBoilerplateUtils()

-- declare module root and dependencies
root = {}
dependencies = {}

-- require/import dependencies
requireModule("RobloxLibraries")
requireModule("HttpService")
requireModule("DataService")
requireModule("UserAccountsService")
requireModule("PermissionsService")
requireModule("ApplicationService")
requireModule("CommandsService")
