-- boilerplate code used in major components
local boilerplate = {}

-- for the first release, im going to focus on building features. eventually,
-- ill write a sandbox of some sort.
boilerplate._private = {}

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

function boilerplate.requireModule(modulePath)
  local requestingEnvironment = getfenv(2)

  if (requestingEnvironment.root) then
    local moduleName do
      if (modulePath:sub(#modulePath - 4, #modulePath) == ".lua") then
        moduleName = convertPathToTable(modulePath)
      else
        moduleName = modulePath:gmatch("(%.)%/")
      end
    end

    requestingEnvironment.root[moduleName] = require(modulePath)
  end

  return require(modulePath)
end

function boilerplate.importModule(modulePath)
  local requestingEnvironment = getfenv(2)

  for key, value in next, require(modulePath) do
    requestingEnvironment[key] = value
  end
end

-- importBoilerplateUtils
function boilerplate:importBoilerplateUtils()
  local requestingEnvironment = getfenv(2)

  for key, value in next, boilerplate do
    if not (key == "importBoilerplateUtils") then
      requestingEnvironment[key] = value
    end
  end
end


return boilerplate
