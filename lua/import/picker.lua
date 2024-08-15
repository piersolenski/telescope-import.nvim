local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local conf = require("telescope.config").values
local default_languages = require("import.languages")
local finders = require("telescope.finders")
local get_filetype_config = require("import.get_filetype_config")
local get_project_imports = require("import.get_project_imports")
local insert_line = require("import.insert_line")
local pickers = require("telescope.pickers")
local utils = require("import.utils")

local function picker(opts)
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

  -- add syntax highlighting to the rsults of the picker
  local currentFiletype = vim.bo.filetype
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "TelescopeResults",
    once = true, -- do not affect other Telescope windows
    callback = function(ctx)
      -- add filetype highlighting
      vim.api.nvim_buf_set_option(ctx.buf, "filetype", currentFiletype)

      -- make discernible as the results are now colored
      local ns = vim.api.nvim_create_namespace("telescope-import")
      vim.api.nvim_win_set_hl_ns(0, ns)
      vim.api.nvim_set_hl(ns, "TelescopeMatching", { reverse = true })
    end,
  })

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
          local insert_line_at = (
            filetype_config and filetype_config.insert_at_line or opts.insert_at_line
          )
          local selection = action_state.get_selected_entry()
          insert_line(selection.value, insert_line_at)
        end)
        return true
      end,
    })
    :find()
end

return picker
