local constants = require("import.core.constants")

local ok, snacks = pcall(require, "snacks")
if not ok then
  return function()
    error("snacks.nvim not found. Please install it to use this picker.", 0)
  end
end

local user_layout = snacks.config.picker.layout.layout

local overrides = {
  title = constants.title,
  width = constants.width,
  height = constants.height,
  min_height = constants.min_height,
  min_width = constants.min_width,
}

local layout = vim.tbl_deep_extend("force", user_layout, overrides)

local function snacks_picker(imports, filetype, on_select)
  local formatted_imports = {}

  for _, result in ipairs(imports) do
    table.insert(formatted_imports, { text = result })
  end

  local picker_layout = { layout = layout, preview = false }

  snacks.picker({
    items = formatted_imports,
    confirm = function(picker)
      picker:close()

      local results = {}

      local selected = picker:selected()

      -- Check multi-selection first
      if selected and #selected > 0 then
        for _, selected_item in ipairs(selected) do
          if selected_item and selected_item.text then
            table.insert(results, selected_item.text)
          end
        end
      else
        -- Fall back to current selection if no multi-selection
        local current_selection = picker:current()
        if current_selection and current_selection.text then
          table.insert(results, current_selection.text)
        end
      end

      on_select(results)
    end,
    format = "text",
    formatters = { text = { ft = filetype } },
    layout = picker_layout,
  })
end

return snacks_picker
