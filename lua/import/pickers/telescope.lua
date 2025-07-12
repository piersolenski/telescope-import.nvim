local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local conf = require("telescope.config").values
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")

local function telescope_picker(imports, on_select)
  local formatted_imports = {}

  for _, result in ipairs(imports) do
    table.insert(formatted_imports, { value = result })
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
    .new({}, {
      prompt_title = "Imports",
      sorter = conf.generic_sorter(),
      finder = finders.new_table({
        results = formatted_imports,
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
          print("results [telescope.lua:69]", vim.inspect(results))
          on_select(results)
        end)
        return true
      end,
    })
    :find()
end

return telescope_picker
