--[[

    PigBot Services
  DiscordService/CommandsService.lua ver 0.1.0
  Handles processing of Commands for Users

  Change Log:
    [452017a]
      - Initial publication


Help us improve PigBot Services! Contribute to our source at our public GitHub:
https://github.com/DBReinitialized/PigBot
]]

-- THIS IS A TEMPORARY COMMAND SERVICE BEING USED TO DEBUG
-- A PROBLEM WITH DATASERVICE. I will REWRITE this.

local commandsService = {}
PigBot.DiscordService.CommandsService = commandsService

local commands = {}
local commandLinks = {}
local client = PigBot.DiscordService.clients.UserBotClient
local settings = PigBot.Settings.DiscordService.CommandsService

function commandsService.addCommand(name, links, guildOnly, handler)
  local commandObject = {}
  commandObject.name = name
  commandObject.links = links
  commandObject.handler = handler
  commandObject.guildOnly = guildOnly

  for key, value in next, links do
    commandLinks[value] = commandObject
  end

  commands[name] = commandObject
end

client:on(
  "messageCreate",
  function(message)
    -- ignore the message if it came from us
    if (message.author == client.user) then return end

    -- CommandsService is in DEBUG MODE! Permissions will not be checked
    -- until next rewrite.
    if (message.content:sub(0, #settings.PrefixActivator) == settings.PrefixActivator) then
      local command, argument = message.content:match("(%S+)%s+(.*)")
      command = command or message.content
      command = command:sub(2)
      local isDM = not message.guild

      local commandObject = commandLinks[command]
      if not (commandObject) then
        message.channel:sendMessage("Sorry, but ".. command .." is not registered with PigBot.", {message.author})

      else
        if (commandObject.guildOnly) and (isDM) then
          message.author:sendMessage("Sorry, but ".. commandObject.name .." is only supported on a Guild.")

          return
        else
          local ran, response = pcall(commandObject.handler, {command, argument, message}, {message.author, message.guild, message.channel})

          if not (ran) then
            message.channel:sendMessage("Execute failure! Refer to output for more details.")

            print(response)
            print(debug.traceback())

            return
          end
        end
      end
    end
  end
)

commandsService.addCommand(
  "Execute Lua",
  {"run", "exe", "source"},
  false,

  function(message, data)
    if not (data[1].username == "Reinitialized") then
      data[3]:sendMessage("Sorry, but this command is not available for public use.")

      return
    end

    local compiled = loadstring(message[2])
    if not (compiled) then
      data[3]:sendMessage("Sorry, but this command experienced a compile failure!\n```".. compiled .."```")

      return

    else
      getfenv(compiled).message = message
      getfenv(compiled).data = data

      local ran, response = pcall(compiled)
      if not (ran) then
        data[3]:sendMessage("Sorry, but this command experienced a runtime failure!\n```".. response .."```")

        return
      end


    end
  end
)

-- temporary Commands
commandsService.addCommand(
  "Request presence",
  {"summon", "request", "callfor"},
  true,

  function(message, data)

    local username = string.lower(message[2])
    local memberObject do
      for member in data[2].members do
        print(member.name)

        if (string.lower(member.name):match(username)) then
          memberObject = member

          break
        end
      end
    end

    if (memberObject) then
      memberObject:sendMessage("Hey ".. memberObject.name ..", your presence is requested in #scriptbuilder at Bleu Pigs!")
      data[3]:sendMessage("Successfully pinged ".. memberObject.name, {data[1]})

    else
      data[3]:sendMessage("Failed to find a member matching ".. message[2], {data[1]})
    end
  end
)
