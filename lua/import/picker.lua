local actions = require("telescope.actions")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local conf = require("telescope.config").values
local action_state = require("telescope.actions.state")
local utils = require("import.utils")
local filetypes = require("import.filetypes")

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

local function insert_line(value, insert_at_top)
  local original_position

  if insert_at_top then
    original_position = vim.fn.getpos(".")
    vim.cmd("normal! gg")
  end

  vim.api.nvim_put({ value }, "l", false, false)

  if insert_at_top then
    vim.fn.setpos(".", original_position)
  end
end

local function get_filetype_config(filetype)
  for _, config in ipairs(filetypes) do
    for _, ft in ipairs(config.filetypes) do
      if ft == filetype then
        return config
      end
    end
  end
  return nil
end

local function find_imports()
  local filetype = utils.get_filetype()
  local config = get_filetype_config(filetype)

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

local function picker(opts)
  local imports = find_imports()

  if imports == nil then
    vim.notify("Filetype not supported", vim.log.levels.ERROR)
    return nil
  end

  if next(imports) == nil then
    vim.notify("No imports found", vim.log.levels.INFO)
    return nil
  end

  pickers
    .new(opts, {
      prompt_title = "Imports",
      sorter = conf.generic_sorter(opts),
      finder = finders.new_table({
        results = imports,
        entry_maker = function(import)
          return {
            value = import.value,
            display = import.value,
            ordinal = import.value,
          }
        end,
      }),
      attach_mappings = function(prompt_bufnr, _)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          insert_line(selection.value, opts.insert_at_top)
        end)
        return true
      end,
    })
    :find()
end

return picker
