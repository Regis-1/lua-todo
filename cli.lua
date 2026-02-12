local TaskRegistry = require("taskregistry")

local CLI = {}
CLI.__index = CLI

local function list_tasks(tasks)
  for i, t in ipairs(tasks) do
    print(string.format("%d. %s", i, t))
  end
end

local function print_usage()
  print(
    [=[Usage:
  luajit todo.lua [operation]

Operations:
--list
--add <task description> [due date]
--remove <task id>
]=]
  )
end

local commands = {
  ["--list"] = {
    min_args = 0,
    handler = function(list, args)
      list_tasks(list.tasks)
      return false
    end
  },

  ["--add"] = {
    min_args = 1,
    handler = function(list, args)
      local description = args[2]
      local due_date = args[3]

      local task = TaskRegistry.new_task(description, due_date)
      list:add(task)

      return true
    end
  },

  ["--remove"] = {
    min_args = 1,
    handler = function(list, args)
      local id = tonumber(args[2])

      list:remove(id)
      return true
    end
  },

  ["--toggle"] = {
    min_args = 1,
    handler = function(list, args)
      local id = tonumber(args[2])

      list:toggle(id)
      return true
    end
  },

  ["--help"] = {
    min_args = 0,
    handler = function(list, args)
      print_usage()
    end
  }
}

function CLI.run(args, list)
  local command = args[1]

  if not command then
    print("Error: Interactive mode not yet implemented.")
    return false
  end

  command = commands[command]

  if not command then
    print("Error: Unknown command.\n")
    print_usage()
    return false
  end

  local provided_args = #args - 1
  if provided_args < command.min_args then
    print("Error: Missing argument.\n")
    print_usage()
    return false
  end

  return command.handler(list, args)
end

return CLI
