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

pigBot.threadScheduler.spawn(
	function()
		pigBot.threadScheduler.suspend(1)
		print("i think u good bro")
		pigBot.threadScheduler.suspend(3)
		print("l0l ya u good")
	end
)

-- give control over to the ThreadScheduler
pigBot.threadScheduler:startScheduler()
