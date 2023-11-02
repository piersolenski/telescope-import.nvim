local filetypes = {
  {
    regex = [[(?m)^(?:from[ ]+(\S+)[ ]+)?import[ ]+(\S+)[ ]*$]],
    filetypes = { "python" },
    extensions = { "py" },
  },
  {
    regex = [[^(?:local (\w+) = require\([\"'](.*?)[\"']\))]],
    filetypes = { "lua" },
    extensions = { "lua" },
  },
  {
    regex = [[^(?:import(?:[\"'\s]*([\w*{}\n, ]+)from\s*)?[\"'\s](.*?)[\"'\s].*)]],
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact"},
    extensions = { "js", "jsx", "ts", "tsx" },
  },
  {
    regex = [[^(?:#include <.*>)]],
    filetypes = { "c", "cpp" },
    extensions = { "h", "c", "cpp" },
  },
}

return filetypes
