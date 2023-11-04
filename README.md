# 🚢 telescope-import.nvim

An extension for [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
that allows you to import modules faster based on what you've already imported in your project.

Often we find ourselves importing the same modules over and over again in an existing project. Rather than typing out import statements from scratch or yanking them from other existing files, `telescope-import.nvim` searches your project for existing import statements giving you a faster way to add them to the current buffer.

https://github.com/piersolenski/telescope-import.nvim/assets/1285419/014753e3-ea7b-4bad-9f86-fb2566bf27c1

## 🤖 Supported languages

- Bash/Z shell
- C++
- Javascript / Typescript
- Lua
- PHP
- Python

## 🔩 Installation

Install [ripgrep](https://github.com/BurntSushi/ripgrep).
 
```lua
-- Lazy
{
  'piersolenski/telescope-import.nvim',
  requires = 'nvim-telescope/telescope.nvim'
  config = function()
    require("telescope").load_extension("import")
  end
}

## ⚙️ Configuration

```lua
require("telescope").setup({
  extensions = {
    import = {
      -- Add imports to the top of the file keeping the cursor in place
      insert_at_top = true,
      -- Support additional languages
      custom_languages = {
        {
          -- The regex pattern for the import statement
          regex = [[^(?:import(?:[\"'\s]*([\w*{}\n, ]+)from\s*)?[\"'\s](.*?)[\"'\s].*)]],
          -- The Vim filetypes
          filetypes = { "typescript", "typescriptreact", "javascript", "react" },
          -- The filetypes that ripgrep supports (find these via `rg --type-list`)
          extensions = { "js", "ts" },
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

