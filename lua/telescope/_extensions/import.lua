local config = require("import.config")
local has_telescope, telescope = pcall(require, "telescope")
local import = require("import")
local validate_config = require("import.validate_config")

if not has_telescope then
  error("Install nvim-telescope/telescope.nvim to use import.nvim.")
end

local options = {}

return telescope.register_extension({
  setup = function(external_opts, _)
    options = vim.tbl_deep_extend("force", config.default_options, external_opts)
    validate_config(options)
  end,
  exports = {
    import = function()
      import.pick(options)
    end,
  },
})
