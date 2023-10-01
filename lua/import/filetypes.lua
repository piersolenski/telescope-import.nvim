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
    filetypes = { "typescript", "typescriptreact", "javascript", "react" },
    extensions = { "js", "ts" },
  },
  {
    regex = [[^(?:#include [\"<].*[\">])\s*]],
    filetypes = { "c", "cpp" },
    extensions = { "h", "c", "cpp" },
  },
}

return filetypes
