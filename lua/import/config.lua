local validate_config = require("import.validate_config")

local M = {}

M.options = {}

M.setup = function(opts)
  opts = opts or {}

  local default_opts = {
    custom_languages = {},
    insert_at_top = true,
    picker = "telescope",
  }

  local merged_opts = vim.tbl_deep_extend("force", default_opts, opts)

  validate_config(merged_opts)

  M.options = vim.tbl_extend("force", M.options, merged_opts)
end

return M
