-- Luacheck configuration for Neovim plugin
globals = {
  "vim",
}

ignore = {
  "631", -- max_line_length
}

-- Allow vim global in test files
files["tests/**/*.lua"] = {
  globals = {
    "vim",
    "describe",
    "it",
    "before_each",
    "assert",
  }
}