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
require("./BoilerUtilities.lua"):importBoilerplateUtils()

root = {}

-- until I can implement a sandbox in a later release, all developers
-- are expected to respect the _private space
root._private = {} do
  local _private = root._private

end

-- load dependencies
requireModule("./DataService")
requireModule("./UserAccountsService")
