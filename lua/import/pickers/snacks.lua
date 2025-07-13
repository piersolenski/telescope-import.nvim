local constants = require("import.constants")

local ok, pick = pcall(require, "snacks.picker")
if not ok then
  return function()
    error("snacks.nvim not found. Please install it to use this picker.", 0)
  end
end

local function snacks_picker(imports, filetype, on_select)
  local formatted_imports = {}

  for _, result in ipairs(imports) do
    table.insert(formatted_imports, { text = result })
  end

  pick({
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
    layout = {
      layout = {
        height = constants.height,
        width = constants.width,
        min_height = constants.in_width,
        min_width = constants.in_width,
        box = "vertical",
        border = constants.border,
        title = constants.title,
        { win = "input", height = 1, border = "bottom" },
        { win = "list", border = "none" },
      },
    },
  })
end

return snacks_picker
