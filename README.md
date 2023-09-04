# 🚢 telescope-import.nvim

An extension for [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
that allows you to quickly import/require modules.

## Supported languages

- Javscript / Typescript
- Lua
- Python

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
