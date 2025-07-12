local default_languages = require("import.languages")
local get_filetype_config = require("import.get_filetype_config")
local get_project_imports = require("import.get_project_imports")
local insert_line = require("import.insert_line")
local picker = require("import.picker")
local utils = require("import.utils")

local function run(opts)
  local languages = utils.concat_tables(opts.custom_languages, default_languages)
  local filetype = utils.get_filetype()
  local filetype_config = get_filetype_config(languages, filetype)
  local imports = get_project_imports(filetype_config)

  if imports == nil then
    vim.notify("Filetype not supported", vim.log.levels.ERROR)
    return nil
  end

  if next(imports) == nil then
    vim.notify("No imports found", vim.log.levels.INFO)
    return nil
  end

  local function on_select(results)
    local default_insertion_line = 1
    local insert_at_line = (
      filetype_config and filetype_config.insert_at_line or default_insertion_line
    )
    local should_insert_at_top = opts.insert_at_top

    -- Insert each result on consecutive lines
    for i, result in ipairs(results) do
      local current_line = should_insert_at_top and (insert_at_line + i - 1) or nil
      insert_line(result, current_line)
    end
  end

  picker.create(opts.picker or "telescope", imports, on_select)
end

return run
