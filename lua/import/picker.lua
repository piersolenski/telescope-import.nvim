local pickers = {
  telescope = require("import.pickers.telescope"),
  snacks = require("import.pickers.snacks"),
}

local function create_picker(picker_type, imports, filetype, on_select)
  local picker = pickers[picker_type]
  if not picker then
    vim.notify("Picker not found: " .. picker_type, vim.log.levels.ERROR)
    return
  end
  picker(imports, filetype, on_select)
end

return {
  create = create_picker,
}
