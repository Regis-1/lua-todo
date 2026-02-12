local TaskList = {}
TaskList.__index = TaskList

function TaskList.new()
  return setmetatable({tasks = {}}, TaskList)
end

function TaskList:add(task)
  table.insert(self.tasks, task)
end

function TaskList:remove(id)
  for i, t in ipairs(self.tasks) do
    if t.id == id then
      table.remove(self.tasks, i)
    end
  end
end

function TaskList:toggle(id)
  for i, t in ipairs(self.tasks) do
    if t.id == id then
      t:toggle()
    end
  end
end

function TaskList:restore(tasks)
  self.tasks = tasks
end

return TaskList
