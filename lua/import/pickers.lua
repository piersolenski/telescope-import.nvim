local pickers = {
  telescope = function(...)
    require("import.pickers.telescope")(...)
  end,
  snacks = function(...)
    require("import.pickers.snacks")(...)
  end,
  ["fzf-lua"] = function(...)
    require("import.pickers.fzf")(...)
  end,
}

return pickers
