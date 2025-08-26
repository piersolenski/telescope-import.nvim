local config = require("import.core.config")
local create_picker = require("import.core.create_picker")
local default_languages = require("import.language.languages")
local get_filetype_config = require("import.core.get_filetype_config")
local get_project_imports = require("import.core.get_project_imports")
local insert_line = require("import.core.insert_line")
local utils = require("import.core.utils")

local function pick(opts)
  local options = opts or config.options

  -- Custom languages are placed first to take precedence over default configurations
  local languages = utils.concat_tables(options.custom_languages or {}, default_languages)
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
    local insert_at_line_config = (
      filetype_config and filetype_config.insert_at_line or default_insertion_line
    )

    local insert_at_line
    if type(insert_at_line_config) == "function" then
      insert_at_line = insert_at_line_config()
    else
      insert_at_line = insert_at_line_config
    end

    local should_insert_at_top = options.insert_at_top

    -- Insert each result on consecutive lines
    for i, result in ipairs(results) do
      local current_line = should_insert_at_top and (insert_at_line + i - 1) or nil
      insert_line(result, current_line)
    end
  end

  create_picker(options, imports, filetype, on_select)
end

return pick
