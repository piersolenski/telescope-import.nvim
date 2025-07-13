local pickers = require("import.pickers")

local function create_picker(picker_type, imports, filetype, on_select)
  local picker = pickers[picker_type]
  if not picker then
    vim.notify("Picker not found: " .. picker_type, vim.log.levels.ERROR)
    return
  end
  local ok, err = pcall(picker, imports, filetype, on_select)
  if not ok then
    err = err or "Unknown error occurred"
    vim.notify(err, vim.log.levels.ERROR)
  end
end

return create_picker
