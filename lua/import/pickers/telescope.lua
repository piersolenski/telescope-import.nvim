local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local constants = require("import.core.constants")
local conf = require("telescope.config").values
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")

local function telescope_picker(imports, filetype, on_select, opts)
  opts = opts or {}
  local formatted_imports = {}

  for _, result in ipairs(imports) do
    table.insert(formatted_imports, { value = result })
  end

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "TelescopeResults",
    once = true, -- Do not affect other Telescope windows
    callback = function(ctx)
      -- Add filetype highlighting
      vim.bo[ctx.buf].filetype = filetype

      -- Make discernible as the results are now colored
      local ns = vim.api.nvim_create_namespace("import.nvim")
      vim.api.nvim_win_set_hl_ns(0, ns)
      vim.api.nvim_set_hl(ns, "TelescopeMatching", { reverse = true })
    end,
  })

  local picker_opts = vim.tbl_deep_extend(
    "force",
    {
      prompt_title = constants.title,
      sorter = conf.generic_sorter(),
      layout_config = {
        height = constants.height,
        width = constants.min_width,
      },
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
          on_select(results)
        end)
        return true
      end,
    },
    opts
  )

  pickers.new(picker_opts):find()
end

return telescope_picker
