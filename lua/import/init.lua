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

local function import_picker(opts)
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

  -- Add syntax highlighting to the results of the picker
  local currentFiletype = vim.bo.filetype
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "TelescopeResults",
    once = true, -- Do not affect other Telescope windows
    callback = function(ctx)
      -- Add filetype highlighting
      vim.bo[ctx.buf].filetype = currentFiletype

      -- Make discernible as the results are now colored
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
          local picker = action_state.get_current_picker(prompt_bufnr)

          local multi_selection = picker:get_multi_selection()
          local current_selection = action_state.get_selected_entry()

          -- Process the selections
          local results = {}

          -- Check multi-selection first
          if #multi_selection > 0 then
            for _, item in ipairs(multi_selection) do
              if item and item.value then
                table.insert(results, item.value)
              end
            end
          else
            -- Fall back to current selection if no multi-selection
            if current_selection and current_selection.value then
              table.insert(results, current_selection.value)
            end
          end

          actions.close(prompt_bufnr)

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
        end)
        return true
      end,
    })
    :find()
end

return import_picker
