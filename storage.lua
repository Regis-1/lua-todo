local Storage = {}
Storage.__index = Storage

local function serialize_value(value)
  if type(value) == "string" then
    return string.format("%q", value)
  elseif type(value) == "number" or type(value) == "boolean" then
    return tostring(value)
  else
    return "nil"
  end
end

function Storage.load(path, rehydrate)
  local env = {}

  local chunk, err = loadfile(path, 't', env)
  if not chunk then
    return nil, err
  end

  local ok, result = pcall(chunk)
  if not ok then
    return nil, result
  end

  if type(result) ~= "table" then
    return nil, "Data file must return a table"
  end

  local last_id = result.last_id
  local tasks = result.tasks

  if rehydrate then
    for _, t in ipairs(tasks) do
      rehydrate(t)
    end
  end

  return last_id, tasks
end

function Storage.save(path, tasks, last_id)
  local f = assert(io.open(path, 'w'))
  f:write("return {\n")
  f:write(string.format("  last_id = %d,\n", last_id))
  f:write("  tasks = {\n")
  for _, t in ipairs(tasks) do
    f:write("    {")
    local first = true
    for k, v in pairs(t) do
      if not first then f:write(", ") end
      first = false
      f:write(string.format("%s = %s", k, serialize_value(v)))
    end
    f:write("},\n")
  end
  f:write("  }\n")
  f:write("}\n")
  f:close()
end

return Storage
