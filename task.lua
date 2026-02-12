local Task = {}
Task.__index = Task

local last_id = 0

local function generate_id()
  last_id = last_id + 1
  return last_id
end

function Task:__tostring_parts()
  local check_mark = self.completed and "[x]" or "[ ]"

  return {
    check_mark,
    self.name,
    "[ID: " .. self.id .. "]"
  }
end

function Task:__tostring()
  return table.concat(self:__tostring_parts(), " ")
end

function Task:toggle()
  self.completed = not self.completed
end

function Task.new(name, id)
  local self = setmetatable({}, Task)
  self.class = "Task"
  if id then
    self.id = id
  else
    self.id = generate_id()
  end
  self.name = name
  self.completed = false

  return self
end

function Task.get_last_id()
  return last_id
end

function Task.sync_last_id(id)
  last_id = id
end

return Task
