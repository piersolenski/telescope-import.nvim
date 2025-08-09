local config = require("import.core.config")
local create_picker = require("import.core.create_picker")
local default_languages = require("import.language.languages")
local get_filetype_config = require("import.core.get_filetype_config")
local get_project_imports = require("import.core.get_project_imports")
local insert_line = require("import.core.insert_line")
local utils = require("import.core.utils")

local function pick(opts)
  local options = opts or config.options

local filetype = utils.get_filetype()
-- Custom languages first so they take precedence over defaults
local languages = utils.concat_tables(
  vim.deepcopy(options.custom_languages or {}),
  vim.deepcopy(default_languages)
)
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
    local insertion_base_line = (
      filetype_config and filetype_config.insert_at_line or default_insertion_line
    )
    if type(insertion_base_line) == "function" then
      insertion_base_line = insertion_base_line()
    end
    if type(insertion_base_line) ~= "number" then
      error(
        "Expected insert_at_line to be a number or return a number, but got "
          .. type(insertion_base_line)
      )
    end
    local should_insert_at_top = options.insert_at_top

    -- Insert each result on consecutive lines
    for i, result in ipairs(results) do
      local current_line = should_insert_at_top and (insertion_base_line + i - 1) or nil
      insert_line(result, current_line)
    end
  end

  create_picker(options.picker, imports, filetype, on_select)
end

return pick
