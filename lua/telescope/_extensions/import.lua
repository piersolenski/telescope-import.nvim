local has_telescope, telescope = pcall(require, "telescope")
local picker = require("import.picker")
local validate_config = require("import.validate_config")

if not has_telescope then
  error("Install nvim-telescope/telescope.nvim to use telescope-import.nvim.")
end

local opts = {}
local default_opts = {
  custom_languages = {},
  insert_at_top = true,
}

return telescope.register_extension({
  setup = function(external_opts, _)
    validate_config(external_opts)

    opts = vim.tbl_extend("force", default_opts, external_opts)
  end,
  exports = {
    import = function()
      picker(opts)
    end,
  },
})
