--[[

  Dream Foundations
  Foundations/LuaSignal/init.lua ver 1.0.0 indev
  Main script for initializng the LuaSignals package

  Changelog:
    [4152017a]
      - Initial release of code base

]]

local foundation = _G.foundation("GVp6kjhNUK")

local luaSignals = {}
local _private = foundation._private.internals.getPrivateSpace("luaSignals")

-- localize dependencies
local threadScheduler = _private.threadScheduler

_private.signals = setmetatable({}, {_mode = "k"})

function luaSignals.createSignal()
  local luaSignal = {}

  luaSignal._connections = setmetatable({}, {__mode = "k"})
  luaSignal._waitingThreads = {}

  function luaSignal:fire(...)
    for _ = 1, #luaSignal._waitngThreads do
      local removedThread = table.remove(luaSignal, 1)

      coroutine.resume(removedThread, ...)
    end
    for connection in next, luaSignal._connections do
      threadScheduler.spawn(connection.__callback, ...)
    end
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

      connection.__callback = callback
      connection.connected = true

      function connection:disconnect()
        assert(self == connection, "this function must be called using \":\" on its originating table")

        luaSignal.__connections[connection] = nil
        connection.connected = false
      end

      function connection:destroy()
        assert(self == connection, "this function must be called using \":\" on its originating table")

        connection:disconnect()

        connection.connected = nil
        connection.__callback = nil
        connection = nil
      end

      luaSignal.__connection[connection] = true
      return connection
    end

    function event:wait()
      assert(self == event, "this function must be called using \":\" on its originating table")

      table.insert(luaSignal._waitingThreads, coroutine.running())
      return threadScheduler.suspend(1e10)
    end
  end

  _private.signals[luaSignal] = true
  return luaSignal
end

foundations.luaSignals = luaSignals
