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

-- require dependencies
local DataService = requireModule("./DataService")
local RobloxLibraries = requireModule("./RobloxLibraries")

-- properties/variables
local memberJoinedServerSignal = RobloxLibraries.LuaSignals.new()
local memberLeftServerSignal = RobloxLibraries.LuaSignals.new()
local memberDatabase = DataService.createDatabase("Member Database")
local memberCache = {}


-- main API begin
memberJoinedServerSignal.Event:connect(
  function(newMember)

  end
)


return root
