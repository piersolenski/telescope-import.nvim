local languages = {
  {
    extensions = { "sh", "zsh" },
    filetypes = { "sh", "zsh" },
    regex = [[^(?:source\s+)]],
  },
  {
    extensions = { "java" },
    filetypes = { "java" },
    regex = [[^import\s+((static\s+)?[\w.]+\*?);\s*$]],
  },
  {
    extensions = { "py" },
    filetypes = { "python" },
    regex = [[(?m)^(?:from\s+(\S+)\s+)?import\s+([^#\n]+)]],
  },
  {
    extensions = { "js", "ts" },
    filetypes = { "vue", "javascript", "javascriptreact", "typescript", "typescriptreact" },
    regex = [[^(?:import(?:[\"'\s]*([\w*{}\n, ]+)from\s*)?[\"'\s](.*?)[\"'\s].*)]],
  },
  {
    extensions = { "lua" },
    filetypes = { "lua" },
    regex = [[^(?:local\s+\w+\s*=\s*)?require\(["'](.-)["']\)]],
  },
  {
    extensions = { "h", "c", "cpp" },
    filetypes = { "c", "cpp" },
    regex = [[^(?:#include [\"<].*[\">])\s*]],
  },
  {
    extensions = { "php" },
    filetypes = { "php" },
    regex = [[^\s*use\s+([\w\\]+)(?:\s*;)?]],
  },
  {
    extensions = { "swift" },
    filetypes = { "swift" },
    regex = [[^import\s+(\w+)\s*$]],
  },
}

return languages
