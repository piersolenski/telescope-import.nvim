---@module 'luassert'

local config = require("import.core.config")
local default_languages = require("import.language.languages")
local get_filetype_config = require("import.core.get_filetype_config")
local utils = require("import.core.utils")

describe("Custom Languages", function()
  before_each(function()
    -- Reset config before each test
    config.options = {}
  end)

  describe("Config setup", function()
    it("accepts valid custom_languages config", function()
      local opts = {
        custom_languages = {
          {
            extensions = { "elm" },
            filetypes = { "elm" },
            regex = [[^import\s+([\w.]+)]],
          },
        },
      }

      assert.has_no.errors(function()
        config.setup(opts)
      end)

      assert.are.same(opts.custom_languages, config.options.custom_languages)
    end)

    it("accepts empty custom_languages config", function()
      local opts = {
        custom_languages = {},
      }

      assert.has_no.errors(function()
        config.setup(opts)
      end)

      assert.are.same({}, config.options.custom_languages)
    end)

    it("accepts custom_languages with insert_at_line function", function()
      local opts = {
        custom_languages = {
          {
            extensions = { "vue" },
            filetypes = { "vue" },
            regex = [[^import\s+.*from\s+['\"](.+)['\"];?]],
            insert_at_line = function()
              return 5
            end,
          },
        },
      }

      assert.has_no.errors(function()
        config.setup(opts)
      end)

      assert.are.equal("function", type(config.options.custom_languages[1].insert_at_line))
    end)

    it("accepts custom_languages with insert_at_line number", function()
      local opts = {
        custom_languages = {
          {
            extensions = { "test" },
            filetypes = { "test" },
            regex = [[^test\s+(.+)]],
            insert_at_line = 3,
          },
        },
      }

      assert.has_no.errors(function()
        config.setup(opts)
      end)

      assert.are.equal(3, config.options.custom_languages[1].insert_at_line)
    end)
  end)

  describe("Language merging", function()
    it("merges custom languages with default languages", function()
      local custom_languages = {
        {
          extensions = { "elm" },
          filetypes = { "elm" },
          regex = [[^import\s+([\w.]+)]],
        },
      }

      local merged = utils.concat_tables(custom_languages, default_languages)

      -- Should have all default languages plus the custom one
      assert.are.equal(#default_languages + 1, #merged)

      -- First entry should be the custom language
      assert.are.same(custom_languages[1], merged[1])
    end)

    it("allows custom language to override default language behavior", function()
      local custom_languages = {
        {
          extensions = { "js", "ts" },
          filetypes = { "vue" },
          regex = [[^custom_import\s+(.+)]],
        },
      }

      local merged = utils.concat_tables(custom_languages, default_languages)

      -- Find the custom Vue config (should be first)
      local custom_vue_config = get_filetype_config(merged, "vue")
      assert.are.equal([[^custom_import\s+(.+)]], custom_vue_config.regex)
    end)
  end)

  describe("get_filetype_config with custom languages", function()
    it("returns custom language config when available", function()
      local custom_languages = {
        {
          extensions = { "elm" },
          filetypes = { "elm" },
          regex = [[^import\s+([\w.]+)]],
        },
      }

      local merged = utils.concat_tables(custom_languages, default_languages)
      local elm_config = get_filetype_config(merged, "elm")

      assert.is_not.Nil(elm_config)
      assert.are.same({ "elm" }, elm_config.extensions)
      assert.are.same({ "elm" }, elm_config.filetypes)
      assert.are.equal([[^import\s+([\w.]+)]], elm_config.regex)
    end)

    it("returns custom config over default for same filetype", function()
      local custom_languages = {
        {
          extensions = { "lua" },
          filetypes = { "lua" },
          regex = [[^custom_require\s+(.+)]],
        },
      }

      local merged = utils.concat_tables(custom_languages, default_languages)
      local lua_config = get_filetype_config(merged, "lua")

      -- Should return the custom config (first match)
      assert.are.equal([[^custom_require\s+(.+)]], lua_config.regex)
    end)

    it("falls back to default config when no custom config matches", function()
      local custom_languages = {
        {
          extensions = { "elm" },
          filetypes = { "elm" },
          regex = [[^import\s+([\w.]+)]],
        },
      }

      local merged = utils.concat_tables(custom_languages, default_languages)
      local python_config = get_filetype_config(merged, "python")

      -- Should return default Python config
      assert.is_not.Nil(python_config)
      assert.are.same({ "py" }, python_config.extensions)
    end)

    it("returns nil for unsupported filetype", function()
      local custom_languages = {}
      local merged = utils.concat_tables(custom_languages, default_languages)
      local filetype_config = get_filetype_config(merged, "unsupported")

      assert.is.Nil(filetype_config)
    end)
  end)

  describe("Real world custom language examples", function()
    it("supports Elm language configuration", function()
      local custom_languages = {
        {
          extensions = { "elm" },
          filetypes = { "elm" },
          regex = [[^import\s+([\w.]+)(?:\s+as\s+\w+)?(?:\s+exposing\s+.+)?]],
        },
      }

      local merged = utils.concat_tables(custom_languages, default_languages)
      local elm_config = get_filetype_config(merged, "elm")

      assert.is_not.Nil(elm_config)
      assert.are.same({ "elm" }, elm_config.extensions)
      assert.are.same({ "elm" }, elm_config.filetypes)
      assert.are.equal(
        [[^import\s+([\w.]+)(?:\s+as\s+\w+)?(?:\s+exposing\s+.+)?]],
        elm_config.regex
      )
    end)

    it("supports Vue.js custom insertion configuration", function()
      local custom_languages = {
        {
          extensions = { "vue" },
          filetypes = { "vue" },
          regex = [[^import\s+.*from\s+['\"](.+)['\"];?]],
          insert_at_line = function()
            return 5 -- Simulated line after <script> tag
          end,
        },
      }

      local merged = utils.concat_tables(custom_languages, default_languages)
      local vue_config = get_filetype_config(merged, "vue")

      assert.is_not.Nil(vue_config)
      assert.are.equal("function", type(vue_config.insert_at_line))
      assert.are.equal(5, vue_config.insert_at_line())
    end)

    it("supports multiple custom languages", function()
      local custom_languages = {
        {
          extensions = { "elm" },
          filetypes = { "elm" },
          regex = [[^import\s+([\w.]+)]],
        },
        {
          extensions = { "purescript" },
          filetypes = { "purescript" },
          regex = [[^import\s+([\w.]+)]],
        },
      }

      local merged = utils.concat_tables(custom_languages, default_languages)

      local elm_config = get_filetype_config(merged, "elm")
      local purescript_config = get_filetype_config(merged, "purescript")

      assert.is_not.Nil(elm_config)
      assert.is_not.Nil(purescript_config)
      assert.are.same({ "elm" }, elm_config.filetypes)
      assert.are.same({ "purescript" }, purescript_config.filetypes)
    end)
  end)

  describe("Edge cases", function()
    it("handles custom language with no extensions", function()
      local custom_languages = {
        {
          extensions = {},
          filetypes = { "test" },
          regex = [[^test\s+(.+)]],
        },
      }

      local merged = utils.concat_tables(custom_languages, default_languages)
      local test_config = get_filetype_config(merged, "test")

      assert.is_not.Nil(test_config)
      assert.are.same({ "test" }, test_config.filetypes)
      assert.are.same({}, test_config.extensions)
    end)

    it("handles custom language with multiple filetypes", function()
      local custom_languages = {
        {
          extensions = { "test" },
          filetypes = { "test1", "test2", "test3" },
          regex = [[^test\s+(.+)]],
        },
      }

      local merged = utils.concat_tables(custom_languages, default_languages)

      local test1_config = get_filetype_config(merged, "test1")
      local test2_config = get_filetype_config(merged, "test2")
      local test3_config = get_filetype_config(merged, "test3")

      assert.is_not.Nil(test1_config)
      assert.is_not.Nil(test2_config)
      assert.is_not.Nil(test3_config)

      -- All should be the same config object
      assert.are.equal(test1_config, test2_config)
      assert.are.equal(test2_config, test3_config)
    end)
  end)
end)

