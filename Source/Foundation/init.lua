--[[

    Dream Foundations
    init.lua ver 0.1.0 indev
    Main script for Dream Foundations.


    Changelog:
      [4142017a]
        - Removed previous PigBot source to begin work
        on Dream Foundation, the framework of PigBot.

      [4142017b]
        - Implemented _private space system
        - Implemented basic packaging system
        - Implemented protected Global access
]]

local foundation = {}

foundation._private = {} do
  local _private = foundation._private

  -- logic to determine type of luaPlatform we're running on
  _private.luaPlatform = "unidentified" do
    local luaPlatform = ""
    local isRobloxLua = wait and true or false

    if (isRobloxLua) then
      luaPlatform = "RBX".. _VERSION
      local runService = game:GetService("RunService")

      if (runService:IsServer() and not runService:IsClient()) then
        luaPlatform = luaPlatform .." Server"

      elseif (not runService:IsServer() and runService:IsClient()) then
        luaPlatform = luaPlatform .." Client"

      end

      if (runService:IsStudio()) then
        luaPlatform = luaPlatform .." Studio"
  	  end
      runService = nil
    else
      luaPlatform = _VERSION

      local binaryFormat = package.cpath:match("%p[\\|/]?%p(%a+)")

      if (binaryFormat == "dll") then
        luaPlatform = luaPlatform .." Windows"

      elseif (binaryFormat == "so") then
        luaPlatform = luaPlatform .." Linux"

      elseif (binaryFormat == "dylib") then
        luaPlatform = luaPlatform .." macOS"

      end

      binaryFormat = nil
    end

    _private.luaPlatform = luaPlatform
    luaPlatform = nil
    isRobloxLua = nil
  end

  -- internal functions used by foundation
  _private.internals = {}
end

-- private internal functions
function foundation._private.internals.getPrivateSpace(spaceName)
  -- retrieve private space for module
  local space = foundation._private[spaceName]

  if not (space) then
    foundation._private[spaceName] = {}
    space = foundation._private[spaceName]
  end

  return space
end

-- dependency api
foundation.dependency = {} do
  local dependency = foundation.dependency
  local luaPlatform = foundation._private.luaPlatform

  function dependency.loadPackage(packageName, returnResults)
    assert(type(packageName) == "string", "bad argument #1 (string expected, got ".. type(packageName) ..")")
    returnResults = type(returnResults) == "boolean" and returnResults or false

    local package do
      if (luaPlatform:sub(1, 3) == "RBX") then
        package = script:WaitForChild(packageName)

      else
        package = "./".. packageName

      end
    end

    local results = require(package)

    if (returnResults) then
      return results
    end
  end
end

-- table used to access the "foundation" table.
local foundationGlobalAccess = {} do
  local accessKey = "GVp6kjhNUK"

  local metatable = {}

  function metatable:__call(accessKeyString)
    assert(type(accessKeyString) == "string", "bad argument #1 (string expected, got ".. type(accessKeyString) ..")")

    if (accessKeyString == accessKey) then
      return foundation

    end

    return error("_G.foundation FATAL: access is denied", 2)
  end

  -- lock down and set the metatable
  metatable.__metatable = {
    __call = setfenv(function() end, {})
  }
  setmetatable(foundationGlobalAccess, metatable)

  _G.foundations = foundationGlobalAccess
end

print("Foundation ".. foundation._private.luaPlatform .." has successfully initialized")

-- roblox module compatibility
if (foundation._private.luaPlatform:sub(1, 3) == "RBX") then
  return true
end
