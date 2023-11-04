local actions = require("telescope.actions")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local conf = require("telescope.config").values
local action_state = require("telescope.actions.state")
local utils = require("import.utils")
local default_languages = require("import.languages")
local find_imports = require("import.find_imports")
local insert_line = require("import.insert_line")

local function picker(opts)
  local languages = utils.table_concat(default_languages, opts.custom_languages)

  local imports = find_imports(languages)

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
