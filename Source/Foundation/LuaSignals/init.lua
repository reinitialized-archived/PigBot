--[[

  Dream Foundations
  Foundations/LuaSignal/init.lua ver 1.0.0 indev
  Main script for initializng the LuaSignals package

  Changelog:
    [4152017a]
      - Initial release of code base

]]

local foundations = _G.foundations("GVp6kjhNUK")

local luaSignals = {}
local _private = foundations._private.internals.getPrivateSpace("luaSignals")

-- localize dependencies
local threadScheduler = foundations.threadScheduler

_private.signals = setmetatable({}, {_mode = "k"})

function luaSignals.createSignal()
  local luaSignal = {}

  luaSignal._connections = setmetatable({}, {__mode = "k"})
  luaSignal._waitingThreads = {}

  function luaSignal.fire(self, ...)
    print(debug.traceback())
    print(self, 'running')
    for key = 1, #luaSignal._waitingThreads do
      print(key)
      coroutine.resume(luaSignal._waitingThreads[key], ...)
    end
    for connection in next, luaSignal._connections do
      print(connection, "b")
      threadScheduler.spawn(connection._callback, ...)
    end

    luaSignal._waitingThreads = {}
    print'done'
  end

  function luaSignal:destroy()
    luaSignal._connections = nil
    for key = 1, #luaSignal._waitingThreads do
      coroutine.resume(luaSignal._waitingThreads[key], "signal was destroyed")

    end

    luaSignal._waitingThreads = nil
    luaSignal.fire = nil
    luaSignal.event.connect = nil
    luaSignal.event.wait = nil
    luaSignal.event = nil

    _private.signals[luaSignal] = nil
    luaSignal = nil
  end

  luaSignal.event = {} do
    local event = luaSignal.event

    function event:connect(callback)
      assert(self == event, "this function must be called using \":\" on its originating table")
      assert(type(callback) == "function", "bad argument #1 (function expected, got ".. type(callback) ..")")

      local connection = {}

      connection._callback = callback
      connection.connected = true

      function connection:disconnect()
        assert(self == connection, "this function must be called using \":\" on its originating table")

        luaSignal._connections[connection] = nil
        connection.connected = false
      end

      function connection:destroy()
        assert(self == connection, "this function must be called using \":\" on its originating table")

        connection:disconnect()

        connection.connected = nil
        connection._callback = nil
        connection = nil
      end

      luaSignal._connections[connection] = true
      return connection
    end

    function event:wait()
      assert(self == event, "this function must be called using \":\" on its originating table")

      luaSignal._waitingThreads[#luaSignal._waitingThreads + 1] = coroutine.running()
      return threadScheduler.suspend(1e10)
    end
  end

  _private.signals[luaSignal] = true
  return luaSignal
end

foundations.luaSignals = luaSignals

if (foundations._private.luaPlatform:sub(1, 3) == "RBX") then
  return true
end
