--[[

    PigBot Services
  RobloxLibraries/LuaSignals ver 0.1.0
  Handles

  Change Log:
    [452017a]
      - Initial publication


Help us improve PigBot Services! Contribute to our source at our public GitHub:
https://github.com/DBReinitialized/PigBot
]]

local luaSignal = {}

local dependancies = {}
dependancies.Scheduler = require("./Scheduler")


function luaSignal.new()
  local this = {}

  local connections = {}
  local waitingThreads = {}


  -- main signal api begin
  function this:Fire(...)
    local thread

    for key = 1, #waitingThreads do
      thread = table.remove(waitingThreads, 1)

      print("resuming suspended thread ...")
      coroutine.resume(thread, ...)
    end
    for connection in next, connections do
      dependancies.Scheduler.spawn(connection._callback, ...)
    end
  end

  this.Event = {} do
    function this.Event:connect(callback)
      assert(type(callback) == "function", "bad argument #1 (function expected, got ".. type(callback) ..")")

      local connection = {}

      connection._callback = callback
      connection.connected = true

      function connection:disconnect()
        connections[connection] = nil

        connection.connected = nil
        connection._callback = nil
      end

      connections[connection] = true
      return connection
    end

    function this.Event:wait()
      table.insert(waitingThreads, coroutine.running())

      return dependancies.Scheduler.wait(1e10)
    end
  end

  function this:Destroy()
    for key in next, connections do
      connections[key]:disconnect()
    end

    waitingThreads = nil
    connections = nil

    this.Event.connect = nil
    this.Event.wait = nil
    this.Event = nil
    this.Fire = nil
    this.Destroy = nil
    this = nil
  end

  return this
end


return luaSignal
