--[[

  SessionsManager
    SessionsManager.lua ver 0.1.0
    Utility Module for storing data within Threads

  Change Log:
    [452017a]
      - Initial publication
]]

local sessionsManager = {}

local getSessionByThread = setmetatable(
  {},
  {
    __mode = "k"
  }
)

function sessionsManager.new()
  local this = {}

  this.data = {}
  this.threads = {}

  function this:addThread(thread)
    thread = type(thread) == "coroutine" and thread or coroutine.running()
    assert(not getSessionByThread[thread], "cannot attach thread: thread already registered to another session")

    table.insert(this.threads, thread)
    getSessionByThread[thread] = this
  end

  return this
end

function sessionsManager:getSession(thread)
  thread = type(thread) == "coroutine" and thread or coroutine.running()

  return getSessionByThread[thread]
end

return sessionManager
