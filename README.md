# 🚢 import.nvim

Import modules faster based on what you've already imported in your project.

Often we find ourselves importing the same modules over and over again in an existing project. Rather than typing out import statements from scratch or yanking them from other existing files, `import.nvim` searches your project for existing import statements giving you a faster way to add them to the current buffer. Import patterns are sorted by frequency, so your most used statements are usually just a few keystrokes away. You can select multiple items to import using tab.

For languages that support auto importing through their LSP, `import.nvim` may still be of benefit by importing frequently used patterns of exports, rather than individually importing one at a time, or all at once, which can be inaccurate when there are multiple symbols with the same name in the project.

https://github.com/user-attachments/assets/b5c2d7bd-ced7-44d1-abd2-d96de37a05e8

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
  'piersolenski/import.nvim',
  dependencies = 'nvim-telescope/telescope.nvim',
  config = function()
    require("telescope").load_extension("import")
  end
}
```

## ⚙️ Configuration

`import.nvim` requires no configuration out of the box, but you can tweak it in the following ways:

```lua
require("telescope").setup({
  extensions = {
    import = {
      -- The picker to use. Can be "telescope" or "snacks".
      picker = "telescope",
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

## 🤓 About the author

As well as Vim enthusiast, I am a Front-End Developer and Technical Lead from London, UK.

Whether it's to discuss a project, talk shop or just say hi, I'd love to hear from you!

- [Website](https://www.piersolenski.com/)
- [CodePen](https://codepen.io/piers)
- [LinkedIn](https://www.linkedin.com/in/piersolenski/)

<a href='https://ko-fi.com/piersolenski' target='_blank'>
    <img height='36' style='border:0px;height:36px;' src='https://cdn.ko-fi.com/cdn/kofi1.png?v=3' border='0' alt='Buy Me a Coffee at ko-fi.com' />
</a>
