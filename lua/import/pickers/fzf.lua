local fzf_lua = require("fzf-lua")

local function fzf_picker(imports, _, on_select)
  fzf_lua.fzf_exec(imports, {
    fzf_opts = {
      ["--multi"] = true,
    },
    winopts = {
      width = 100,
      height = 0.62,
      border = "rounded",
      title = " Imports ",
    },
    actions = {
      ["default"] = function(selected)
        on_select(selected)
      end,
    },
  })
end

return fzf_picker
