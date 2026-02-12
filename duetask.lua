local Task = require("task")

local DueTask = {}
DueTask.__index = DueTask
DueTask.__tostring = Task.__tostring
setmetatable(DueTask, Task)

function DueTask:__tostring_parts()
  local parts = Task.__tostring_parts(self)
  table.insert(parts, 3, "(due to " .. self.due_date .. ")")
  return parts
end

function DueTask.new(name, due_date, id)
  local self = Task.new(name, id)
  setmetatable(self, DueTask)

  self.class = "DueTask"
  self.due_date = due_date

  return self
end

return DueTask
