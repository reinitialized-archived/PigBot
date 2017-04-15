--[[

    Dream Foundation
    init.lua ver 0.1.0 indev
    Main script for Dream Foundations.


    Changelog:
      [4142017a]
        - Removed previous PigBot source to begin work
        on Dream Foundation, the framework of PigBot.
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

      luaPlatform = luaPlatform .. runService:IsStudio() and " Studio"
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

    foundation[packageName] = require(package)

    if (returnResults) then
      return foundation[packageName]
    end
  end

  function dependency.getPackage(packageName)
    assert(type(packageName) == "string", "bad argument #1 (string expected, got ".. type(packageName) ..")")

    local package = foundation[packageName]
    if not (package) then
      package = dependency.loadPackage(packageName, true)

    end

    return package
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

  -- Because of how ROBLOX works, we have to use a little exploit to gain access
  -- to the Lua thread's main environment. It's unforunate, but necessary.
  if (foundation._private.luaPlatform:sub(1, 3) == "RBX") then
    local getRealThreadEnvironment = foundation.dependency.getPackage("getRealThreadEnvironment")

    getRealThreadEnvironment().foundation = foundationGlobalAccess

  else
    -- otherwise, we can just use _G lol
    _G.foundation = foundationGlobalAccess

  end
end

print("Foundation has successfully initialized")