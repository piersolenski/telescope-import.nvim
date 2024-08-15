local has_telescope, telescope = pcall(require, "telescope")
local picker = require("import.picker")

if not has_telescope then
  error("Install nvim-telescope/telescope.nvim to use telescope-import.nvim.")
end

local opts = {}
local default_opts = {
  insert_at_line = 1,
  custom_languages = {},
}

return telescope.register_extension({
  setup = function(external_opts, _)
    opts = vim.tbl_extend("force", default_opts, external_opts)
  end,
  exports = {
    import = function()
      -- TODO: Remove this at some point in the future...
      if opts.insert_at_top then
        vim.notify(
          "insert_at_top has been removed from telescope-import.nvim in favour"
            .. " of insert_at_line, see the docs for more information.",
          vim.log.levels.WARN
        )
      end
      picker(opts)
    end,
  },
})
