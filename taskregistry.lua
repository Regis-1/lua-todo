local Task = require("task")
local DueTask = require("duetask")

local Registry = {
  Task = Task,
  DueTask = DueTask
}

function Registry.rehydrate(t)
  local class = Registry[t.class]
  if not class then
    error("Unknown task class: " .. tostring(class))
  end

  return setmetatable(t, class)
end

function Registry.new_task(description, due_date)
  if not due_date then
    return Task.new(description)
  else
    return DueTask.new(description, due_date)
  end
end

function Registry.sync_last_id(last_id)
  Task.sync_last_id(last_id)
end

function Registry.get_last_id()
  return Task.get_last_id()
end

return Registry
