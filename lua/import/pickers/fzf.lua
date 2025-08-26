local constants = require("import.core.constants")

local ok, fzf_lua = pcall(require, "fzf-lua")
if not ok then
  return function()
    error("fzf-lua not found. Please install it to use this picker.", 0)
  end
end

local function fzf_picker(imports, _, on_select, opts)
  opts = opts or {}

  local picker_opts = vim.tbl_deep_extend("force", {
    fzf_opts = {
      ["--multi"] = true,
    },
    winopts = {
      width = constants.min_width,
      height = constants.height,
      border = constants.border,
      title = constants.title,
    },
    actions = {
      ["default"] = function(selected)
        on_select(selected)
      end,
    },
  }, opts)

  fzf_lua.fzf_exec(imports, picker_opts)
end

return fzf_picker
