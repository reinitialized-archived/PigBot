--[[

    PigBot Services
    PigBot.lua ver 0.1.0 indev
    Main script for PigBot Services

    Changelog:
      [4152017a]
        - Initial release for code + test

      [4152017b]
        - Removed test code

]]

require("./Foundation")
local pigBot = _G.foundations("GVp6kjhNUK")

-- load foundation dependencies
pigBot.dependency.loadPackage("ThreadScheduler")
pigBot.dependency.loadPackage("LuaSignals")

local scheduler = pigBot.threadScheduler
local luaSignals = pigBot.luaSignals

local testSignal = luaSignals.createSignal()
local testSignal2 = luaSignals.createSignal()
print(testSignal, testSignal2)

testSignal2.event:connect(
  function(...)
    print(...)
    testSignal:fire(...)
  end
)

-- scheduler.spawn(function()
--   print("thread spawned! waiting for testSignal to give results!")
--   local results = testSignal.event:wait()
--   print("results received!")
--   print(results)
-- end)
-- scheduler.spawn(function()
--   scheduler.suspend(1)
--   testSignal2:fire("a potatoe")
-- end)

scheduler.spawn(function()
  print'yo is the scheduler workin?'
  scheduler.suspend(1)
  print'i think it is dawg'
  scheduler.suspend(3)
  print'lets do a spawn test'
  scheduler.spawn(
    function()
      print'k'
    end
  )
  print'k pausing'
  scheduler.suspend(1)
  print'we good fam'
end)

-- give control over to the ThreadScheduler
pigBot.threadScheduler:startScheduler()
