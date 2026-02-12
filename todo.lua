#!/usr/local/bin/luajit

local TaskRegistry = require("taskregistry")
local TaskList = require("tasklist")
local Storage = require("storage")
local CLI = require("cli")

local function main(args)
  local list = TaskList.new()

  local last_id, tasks = Storage.load("tasks.lua", TaskRegistry.rehydrate)

  TaskRegistry.sync_last_id(last_id or 0)

  if last_id then
    list:restore(tasks)
  end

  local save_tasks = CLI.run(args, list)

  if save_tasks then
    Storage.save("tasks.lua", list.tasks, TaskRegistry.get_last_id())
  end
end

main(arg)
