local utils = require("import.utils")

local function format_types(strings)
  local result = ""
  for i, ext in ipairs(strings) do
    result = result .. "-t " .. ext
    if i < #strings then
      result = result .. " "
    end
  end
  return result
end

local function get_filetype_config(languages, filetype)
  for _, config in ipairs(languages) do
    for _, current_filetype in ipairs(config.filetypes) do
      if current_filetype == filetype then
        return config
      end
    end
  end
  return nil
end

local function find_imports(languages)
  local filetype = utils.get_filetype()
  local config = get_filetype_config(languages, filetype)

  if config == nil then
    return nil
  end

  local types = format_types(config.extensions)
  local flags = { "--no-heading", "--no-line-number", "--color=never", "--no-filename" }

  local find_command = "rg "
    .. types
    .. " "
    .. table.concat(flags, " ")
    .. " "
    .. '"'
    .. config.regex
    .. '"'

  local results = vim.fn.systemlist(find_command)

  results = utils.sort_by_frequency(results)
  results = utils.remove_duplicates(results)

  local imports = {}

  for _, result in ipairs(results) do
    table.insert(imports, { value = result })
  end

  return imports
end

return find_imports
