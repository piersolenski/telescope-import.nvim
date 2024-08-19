local utils = require("import.utils")

-- Returns a string that rg uses to filter filetypes (rg -t)
local function create_file_types_flag(strings)
  local result = ""
  for i, ext in ipairs(strings) do
    result = result .. "-t " .. ext
    if i < #strings then
      result = result .. " "
    end
  end
  return result
end

local function find_imports(config, file_path)
  local types = create_file_types_flag(config.extensions)
  local flags = { "--no-heading", "--no-line-number", "--color=never", "--no-filename" }
  local find_command = table.concat({
    "rg",
    types,
    table.concat(flags, " "),
    string.format('"%s"', config.regex),
  }, " ")

  if file_path then
    find_command = find_command .. " " .. file_path
  end

  return vim.fn.systemlist(find_command)
end

local function get_project_imports(config)
  if config == nil then
    return nil
  end

  local current_file_path = vim.api.nvim_buf_get_name(0)

  local results = find_imports(config)
  local local_results = find_imports(config, current_file_path)

  results = utils.sort_by_frequency(results)
  results = utils.remove_duplicates(results)
  results = utils.remove_entries(results, local_results)

  local imports = {}

  for _, result in ipairs(results) do
    table.insert(imports, { value = result })
  end

  return imports
end

return get_project_imports
