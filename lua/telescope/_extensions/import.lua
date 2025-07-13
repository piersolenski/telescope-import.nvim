local has_telescope, telescope = pcall(require, "telescope")
local import = require("import")

if not has_telescope then
  error("Install nvim-telescope/telescope.nvim to use import.nvim.")
end

return telescope.register_extension({
  exports = {
    import = function()
      import.pick()
    end,
  },
})
