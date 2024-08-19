# 🚢 telescope-import.nvim

An extension for [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
that allows you to import modules faster based on what you've already imported in your project.

Often we find ourselves importing the same modules over and over again in an existing project. Rather than typing out import statements from scratch or yanking them from other existing files, `telescope-import.nvim` searches your project for existing import statements giving you a faster way to add them to the current buffer. Import patterns are sorted by frequency, so your most used statements are usually just a few keystrokes away.

For languages that support auto importing through their LSP, `telescope-import` may still be of benefit by importing frequently used patterns of exports, rather than individually importing one at a time, or all at once, which can be inaccurate when there are multiple symbols with the same name in the project.

https://github.com/piersolenski/telescope-import.nvim/assets/1285419/014753e3-ea7b-4bad-9f86-fb2566bf27c1

## 🤖 Supported languages
- Bash
- C++
- Go
- Java
- JavaScript
- Lua
- PHP
- Python
- Svelte
- Swift
- Typescript
- Vue
- Zsh

## 🔩 Installation

Install [ripgrep](https://github.com/BurntSushi/ripgrep).

```lua
-- Lazy
{
  'piersolenski/telescope-import.nvim',
  dependencies = 'nvim-telescope/telescope.nvim',
  config = function()
    require("telescope").load_extension("import")
  end
}
```

## ⚙️ Configuration

`telescope-import.nvim` requires no configuration out of the box, but you can tweak it in the following ways:

```lua
require("telescope").setup({
  extensions = {
    import = {
      -- Imports can be added at a specified line whilst keeping the cursor in place
      insert_at_top = true,
      -- Optionally support additional languages or modify existing languages...
      custom_languages = {
        {
          -- The filetypes that ripgrep supports (find these via `rg --type-list`)
          extensions = { "js", "ts" },
          -- The Vim filetypes
	   	filetypes = { "vue" },
          -- Optionally set a line other than 1
          insert_at_line = 2 ---@type function|number,
          -- The regex pattern for the import statement
          regex = [[^(?:import(?:[\"'\s]*([\w*{}\n, ]+)from\s*)?[\"'\s](.*?)[\"'\s].*)]],
        },
      },
    },
  },
})
```

## 🚀 Usage

```
:Telescope import
```
