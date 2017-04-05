--[[

  RobloxLibraries
    Scheduler.lua ver 0.1.0
    API for scheduling tasks similar to ROBLOX

  Change Log:
    [452017a]
      - Initial publication
]]

local scheduler = {}

local queuedTasks = {}
local schedulerThread
local schedulerStatus = "Not Started"

local function scheduleTask(task)
  assert(type(task) == "table", "bad argument #1 (table expected, got ".. type(task) ..")")

  table.insert(queuedTasks, task)
  table.sort(
    queuedTasks,
    function(taskA, taskB)
      return taskA.time < taskB.time
    end
  )
end


-- main API
function scheduler.wait(time)
  assert(type(time) == "number", "bad argument #1 (number expected, got ".. type(time) ..")")

  local runningThread = coroutine.running()
  scheduleTask({
    time = os.time() + time,
    thread = runningThread
  })

  return coroutine.yield()
end

function scheduler.delay(time, handler)
  assert(type(time) == "number", "bad argument #1 (number expected, got ".. type(time) ..")")
  assert(type(handler) == "function", "bad argument #2 (function expected, got ".. type(handler) ..")")

  scheduleTask({
    time = os.time() + time,
    thread = coroutine.create(handler)
  })
end

function scheduler.spawn(handler)
  assert(type(handler) == "function", "bad argument #1 (function expected, got ".. type(handler) ..")")

  scheduleTask({
    time = os.time(),
    thread = coroutine.create(handler)
  })
end

-- Initialize Scheduler function
function scheduler.startService()
  local isCoroutine = type(schedulerThread) == "coroutine"

  if not (isCoroutine) or coroutine.status(schedulerThread) == "dead" then
    schedulerThread = coroutine.create(
      function()
        local now, task

        while true do
          if (schedulerStatus == "Suspended") then
            coroutine.yield(os.time())
          end

          now = os.time()

          if (#queuedTasks > 0) and (queuedTasks[1].time <= now) then
            task = table.remove(queuedTasks, 1)

            coroutine.resume(task.thread)
          end
        end
      end
    )

  elseif coroutine.status(schedulerThread) == "suspended" then
    coroutine.resume(schedulerThread, os.time())

  else
    error("Cannot start scheduler: Coroutine status is ".. coroutine.status(schedulerThread), 2)
  end
end

function scheduler.pauseService()
  local isCoroutine = type(schedulerThread) == "coroutine"

  if isCoroutine then
    if (coroutine.status(schedulerThread) == "running" or coroutine.status(schedulerThread) == "normal") then
      schedulerStatus = "Suspended"

    else
      error("Cannot suspend scheduler: Coroutine status is ".. coroutine.status(schedulerThread), 2)
    end

  else
    error("Cannot suspend scheduler: Scheduler was never started!", 2)
  end
end


return scheduler
