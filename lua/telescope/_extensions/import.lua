local has_telescope, telescope = pcall(require, "telescope")
local picker = require("import")
local validate_config = require("import.validate_config")

if not has_telescope then
  error("Install nvim-telescope/telescope.nvim to use import.nvim.")
end

local opts = {}
local default_opts = {
  custom_languages = {},
  insert_at_top = true,
  picker = "snacks",
}

return telescope.register_extension({
  setup = function(external_opts, _)
    opts = vim.tbl_deep_extend("force", default_opts, external_opts)
    validate_config(opts)
  end,
  exports = {
    import = function()
      picker(opts)
    end,
  },
})
