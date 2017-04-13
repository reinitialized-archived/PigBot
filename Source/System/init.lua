--[[

    PigBot Services
  System ver 0.1.0
  Major component for preparing system utilities

  Change Log:
    [452017a]
      - Initial publication


Help us improve PigBot Services! Contribute to our source at our public GitHub:
https://github.com/DBReinitialized/PigBot
]]

-- load boilerplate code
require("./BoilerUtilities.lua"):importBoilerplateUtils()


root = {}

root._private = {} do
  local _private = root._private

  _private.projectName = "PigBot"
  _private.majorVersion = "0.1"
  _private.minorVersion = "0"
  _private.updateBranch = "indev"
  _private.urlUpdatePath = "https://github.com/DBReinitialized/PigBot"

  _private.internal = {}
end



function root.getCurrentVersion()
  return string.format("%s ver %d%.%d %s", root._private.projectName, root._private.majorVersion, root._private.minorVersion, root._private.updateBranch)
end

function root.getMajorVersion()
  return root._private.majorVersion
end

function root.getMinorVersion()
  return root._private.minorVersion
end


return root
