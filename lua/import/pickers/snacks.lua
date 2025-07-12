local pick = require("snacks.picker")

local function snacks_picker(imports, on_select)
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
    format = function(item, _)
      local ret = {}
      ret[#ret + 1] = { item.text }
      return ret
    end,
    layout = {
      layout = {
        backdrop = {
          blend = 40,
        },
        width = 0.3,
        min_width = 80,
        height = 0.2,
        min_height = 10,
        box = "vertical",
        border = "rounded",
        title = " Workspace ",
        title_pos = "center",
        { win = "list", border = "none" },
        { win = "input", height = 1, border = "top" },
      },
    },
  })
end

return snacks_picker
