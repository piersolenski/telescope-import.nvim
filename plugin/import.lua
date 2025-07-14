if vim.fn.has("nvim-0.7.0") == 0 then
  vim.api.nvim_err_writeln("import.nvim requires at least nvim-0.7.0.1")
  return
end

-- Automatically executed on startup
if vim.g.loaded_import then
  return
end

vim.g.loaded_import = true

local import = require("import")

vim.api.nvim_create_user_command("Import", function()
  import.pick()
end, {})
