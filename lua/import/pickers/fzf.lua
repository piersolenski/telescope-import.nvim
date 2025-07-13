local constants = require("import.constants")
local fzf_lua = require("fzf-lua")

local function fzf_picker(imports, _, on_select)
  fzf_lua.fzf_exec(imports, {
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
  })
end

return fzf_picker
