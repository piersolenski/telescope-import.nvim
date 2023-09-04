# 🚢 telescope-import.nvim

An extension for [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
that allows you to quickly import modules based on modules you've already imported elsewhere in your project.

## Supported languages

- Javscript / Typescript
- Lua
- Python

## Dependencies

- [ripgrep](https://github.com/BurntSushi/ripgrep)

## Installation

```lua
-- Lazy
{
  'piersolenski/telescope-import.nvim',
  requires = 'nvim-telescope/telescope.nvim'
  config = function()
    require("telescope").load_extension("import")
  end
}
```

## Usage

```
:Telescope import
```

## Todo

- Update relative files to be relative to the current one
