local validate_config = require("import.core.validate_config")

local M = {}

M.options = {}

M.default_options = {
  custom_languages = {},
  insert_at_top = true,
  picker = "telescope",
}

M.setup = function(opts)
  opts = opts or {}

  local merged_opts = vim.tbl_deep_extend("force", M.default_options, opts)

  validate_config(merged_opts)

  M.options = vim.tbl_extend("force", M.options, merged_opts)
end

return M
