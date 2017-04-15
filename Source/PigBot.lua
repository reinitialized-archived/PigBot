--[[

    PigBot Services
    PigBot.lua ver 0.1.0 indev
    Main script for PigBot Services

    Changelog:
      [4152017a]
        - Initial release for code + test

]]

require("./Foundation")
local pigBot = _G.foundation("GVp6kjhNUK")

-- load foundation dependencies
pigBot.dependency.loadPackage("ThreadScheduler")


pigBot.threadScheduler.spawn(
  function()
    pigBot.threadScheduler.suspend(1)
    print("i think u good fam")
    pigBot.threadScheduler.suspend(3)
    print("ya u good")
  end
)
pigBot.threadScheduler:startScheduler()
