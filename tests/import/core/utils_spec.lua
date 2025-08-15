local utils = require("import.core.utils")

describe("Utils", function()
  describe("get_current_buffer_imports", function()
    it("extracts JavaScript imports from buffer", function()
      -- Create a test buffer with some JavaScript imports
      local bufnr = vim.api.nvim_create_buf(false, true)
      local lines = {
        "import React from 'react'",
        "import { useState } from 'react'",
        "import axios from 'axios'",
        "console.log('not an import')",
        "import './styles.css'",
      }
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

      -- Switch to the test buffer
      vim.api.nvim_set_current_buf(bufnr)

      local config = {
        regex = [[^(?:import(?:[\"'\s]*([\w*{}\n, ]+)from\s*)?[\"'\s](.*?)[\"'\s].*)]],
      }

      local imports = utils.get_current_buffer_imports(config)

      -- Should extract all 4 import statements
      assert.equals(4, #imports)
      assert.truthy(vim.tbl_contains(imports, "import React from 'react'"))
      assert.truthy(vim.tbl_contains(imports, "import { useState } from 'react'"))
      assert.truthy(vim.tbl_contains(imports, "import axios from 'axios'"))
      assert.truthy(vim.tbl_contains(imports, "import './styles.css'"))

      -- Clean up
      vim.api.nvim_buf_delete(bufnr, { force = true })
    end)

    it("returns empty table for nil config", function()
      local imports = utils.get_current_buffer_imports(nil)
      assert.same({}, imports)
    end)

    it("returns empty table for config without regex", function()
      local imports = utils.get_current_buffer_imports({})
      assert.same({}, imports)
    end)
  end)
end)
