local regex = require("import.language.regex")

local languages = {
  {
    extensions = { "h", "c", "cpp" },
    filetypes = { "c", "cpp" },
    regex = regex.c,
  },
  {
    extensions = { "dart" },
    filetypes = { "dart" },
    regex = regex.dart,
  },
  {
    extensions = { "go" },
    filetypes = { "go" },
    regex = regex.go,
  },
  {
    extensions = { "java" },
    filetypes = { "java" },
    regex = regex.java,
  },
  {
    extensions = { "js", "ts" },
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    regex = regex.javascript,
  },
  {
    extensions = { "js", "ts" },
    filetypes = { "vue" },
    regex = regex.javascript,
    insert_at_line = 2,
  },
  {
    extensions = { "js", "ts" },
    filetypes = { "svelte" },
    regex = regex.javascript,
    insert_at_line = 2,
  },
  {
    extensions = { "lua" },
    filetypes = { "lua" },
    regex = regex.lua,
  },
  {
    extensions = { "php" },
    filetypes = { "php" },
    regex = regex.php,
  },
  {
    extensions = { "py" },
    filetypes = { "python" },
    regex = regex.python,
  },
  {
    extensions = { "ruby" },
    filetypes = { "ruby" },
    regex = regex.ruby,
  },
  {
    extensions = { "sh", "zsh" },
    filetypes = { "sh", "zsh" },
    regex = regex.shell,
  },
  {
    extensions = { "swift" },
    filetypes = { "swift" },
    regex = regex.swift,
  },
}

return languages
