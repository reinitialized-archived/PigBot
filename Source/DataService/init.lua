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

-- import Boilerplate Utilities
require("../BoilerUtilities.lua"):importBoilerplateUtils()

root = {}
-- properties/variables
local databases = {}

-- load dependencies
importModule("json")

-- API begins
function root.createDatabase(databaseName)
  assert(type(databaseName) == "string", "bad argument #1 (string expected, got ".. type(databaseName) ..")")

  local this = databases[databaseName]
  if not (this) then
    this = {}

    local filePath = "Source/Components/DataService/Contents/".. databaseName ..".json"
    local file = io.open(filePath, "w") do
      if (not file:read("*a")) then
        file:write("{}")
      end
      io.close(file)
    end
    local data = {}

    function this.SetKey(key, value)
      file = io.open(filePath, "w")

      if (file) then
        data[key] = value

        local jsonData = json.encode(data)
        file:write(jsonData)
        io.close(file)

        return true

      else
        return false

      end
    end

    function this.GetKey(key)
      file = io.open(filePath, "r")

      if (file) then
        local data = file:read("*a")
        data = json.decode(data)
        io.close(file)

        return true, data[key]

      else
        return false

      end
    end

    function this.dumpDatabase()
      file = io.open(filePath, "r")

      if (file) then
        local data = file:read("*a")
        data = json.decode(data)
        io.close(file)

        return true, data

      else
        return false

      end
    end

    databases[databaseName] = this
    return this

  else
    warn("Database ".. databaseName .." already exists! Please use getDatabase instead.")

    return databases[databaseName]
  end
end

function root.getDatabase(databaseName)
  assert(type(databaseName) == "string", "bad argument #1 (string expected, got ".. type(databaseName) ..")")

  local database = databases[databaseName]
  if not (database) then
    error("Database ".. databaseName .." does not exist. Please ensure to use createDatabase!", 2)
  end

  return database
end


return root
