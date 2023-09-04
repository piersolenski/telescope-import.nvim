local actions = require("telescope.actions")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local conf = require("telescope.config").values
local action_state = require("telescope.actions.state")
local utils = require("import.utils")

local filetype_configs = {
  {
    regex = [[(?m)^(?:from[ ]+(\S+)[ ]+)?import[ ]+(\S+)[ ]*$]],
    filetypes = { "python" },
    extensions = { "py" },
  },
  {
    regex = [[^(?:local (\w+) = require\([\"'](.*?)[\"']\))]],
    filetypes = { "lua" },
    extensions = { "lua" },
  },
  {
    regex = [[^(?:import(?:[\"'\s]*([\w*{}\n, ]+)from\s*)?[\"'\s](.*?)[\"'\s].*)]],
    filetypes = { "typescript", "typescriptreact", "javascript", "react" },
    extensions = { "js", "ts" },
  },
}

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

local function get_filetype_config(filetype)
  for _, config in ipairs(filetype_configs) do
    for _, ft in ipairs(config.filetypes) do
      if ft == filetype then
        return config
      end
    end
  end
  return nil
end

local function get_imports()
  local filetype = utils.get_filetype()
  local config = get_filetype_config(filetype)

  if config == nil then
    return nil
  end

  local types = format_types(config.extensions)
  local flags = " --no-heading --no-line-number --color=never --no-filename "

  local find_command = "rg " .. types .. flags .. '"' .. config.regex .. '"'

  local results = vim.fn.systemlist(find_command)

  results = utils.sortByFrequency(results)
  results = utils.removeDuplicates(results)

  local total = {}

  for _, result in ipairs(results) do
    table.insert(total, { value = result })
  end

  return total
end

local function search(opts)
  local imports = get_imports()

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
          local value = selection.value
          vim.api.nvim_put({ value }, "l", false, false)
        end)
        return true
      end,
    })
    :find()
end

return require("telescope").register_extension({
  exports = { import = search },
})
