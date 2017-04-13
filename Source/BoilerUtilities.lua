-- boilerplate code used in major components
local root = {}

-- special local utility used for outside ROBLOXLua only
local function convertPathToTable(path)
  local pathTable = {}
  local result

  for name in path:gmatch("(%.)%/") do
    pathTable[#pathTable + 1] = name
  end

  result = pathTable[#pathTable]
  result = result:gsub(".lua", "")

  return result
end

function root.requireDependency(modulePath)
  local requestingEnvironment = getfenv(2)
  local dependencies = requestingEnvironment.dependencies

  -- verify the requesting environment has its dependencies table,
  -- and create one if not.
  if not (dependencies) then
    requestingEnvironment.dependencies = {}
    dependencies = requestingEnvironment.dependencies

    warn(
    "PigBot.BoilerUtilities warning:\n\tBoilerUtilities.requireDependency could not find \"dependencies\" table for requesting environment."
    )
    print("traceback:", debug.traceback())
  end

  local moduleName
  if (modulePath:sub(#modulePath - 4, #modulePath) == ".lua") then
    moduleName = convertPathToTable(modulePath)
  else
    moduleName = modulePath:gmatch("(%.)%/")
  end

  dependencies[moduleName] = require(modulePath)
  return dependencies[moduleName]
end

function root.imporDependency(modulePath)
  local requestingEnvironment = getfenv(2)

  for key, value in next, require(modulePath) do
    requestingEnvironment[key] = value
  end
end

-- importBoilerplateUtils/s
function root:importBoilerplateUtils()
  local requestingEnvironment = getfenv(2)

  for key, value in next, boilerplate do
    if not (key == "importBoilerplateUtils") then
      requestingEnvironment[key] = value
    end
  end
end


return root
