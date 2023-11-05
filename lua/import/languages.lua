local languages = {
  {
    regex = [[^(?:source\s+)]],
    filetypes = { "sh", "zsh" },
    extensions = { "sh", "zsh" },
  },
  {
    regex = [[^import\s+((static\s+)?[\w.]+\*?);\s*$]],
    filetypes = { "java" },
    extensions = { "java" },
  },
  {
    regex = [[(?m)^(?:from[ ]+(\S+)[ ]+)?import[ ]+(\S+)[ ]*$]],
    filetypes = { "python" },
    extensions = { "py" },
  },
  {
    regex = [[^(?:import(?:[\"'\s]*([\w*{}\n, ]+)from\s*)?[\"'\s](.*?)[\"'\s].*)]],
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    extensions = { "js", "ts" },
  },
  {
    regex = [[^(?:local (\w+) = require\([\"'](.*?)[\"']\))]],
    filetypes = { "lua" },
    extensions = { "lua" },
  },
  {
    regex = [[^(?:#include [\"<].*[\">])\s*]],
    filetypes = { "c", "cpp" },
    extensions = { "h", "c", "cpp" },
  },
  {
    regex = [[^\s*use\s+([\w\\]+)(?:\s*;)?]],
    filetypes = { "php" },
    extensions = { "php" },
  },
}

return languages
