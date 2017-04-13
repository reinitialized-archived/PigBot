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

-- import Boilerplate Utilities
require("../BoilerUtilities.lua"):importBoilerplateUtils()

root = {}

root._private = {} do
  local _private = root._private
