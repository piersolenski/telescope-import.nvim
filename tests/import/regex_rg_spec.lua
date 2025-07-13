local regex = require("import.regex")

describe("Regex with rg", function()
  local test_file = "test_imports.js"

  after_each(function()
    os.remove(test_file)
  end)

  describe("javascript", function()
    it("matches various import statements", function()
      local lines = {
        "import package from 'package';",
        'import { method } from "package";',
        "import { method as myMethod } from 'package';",
        "import * as package from 'package';",
      }
      local file = io.open(test_file, "w")
      for _, line in ipairs(lines) do
        file:write(line .. "\n")
      end
      file:close()

      local find_command = string.format("rg --no-heading --no-line-number --color=never %s %s", vim.fn.shellescape(regex.javascript), test_file)
      local result = vim.fn.systemlist(find_command)

      assert.are.same(lines, result)
    end)
  end)

  describe("python", function()
    it("matches various import statements", function()
      local lines = {
        "import package",
        "from package import method",
        "from package import method1, method2",
        "from package import method as myMethod",
      }
      local file = io.open(test_file, "w")
      for _, line in ipairs(lines) do
        file:write(line .. "\n")
      end
      file:close()

      local find_command = string.format("rg --no-heading --no-line-number --color=never %s %s", vim.fn.shellescape(regex.python), test_file)
      local result = vim.fn.systemlist(find_command)

      assert.are.same(lines, result)
    end)
  end)

  describe("lua", function()
    it("matches various require statements", function()
      local lines = {
        "local package = require('package')",
        'local package = require("package")',
      }
      local file = io.open(test_file, "w")
      for _, line in ipairs(lines) do
        file:write(line .. "\n")
      end
      file:close()

      local find_command = string.format("rg --no-heading --no-line-number --color=never %s %s", vim.fn.shellescape(regex.lua), test_file)
      local result = vim.fn.systemlist(find_command)

      assert.are.same(lines, result)
    end)
  end)

  describe("c", function()
    it("matches various include statements", function()
      local lines = {
        '#include "package.h"',
        "#include <package.h>",
      }
      local file = io.open(test_file, "w")
      for _, line in ipairs(lines) do
        file:write(line .. "\n")
      end
      file:close()

      local find_command = string.format("rg --no-heading --no-line-number --color=never %s %s", vim.fn.shellescape(regex.c), test_file)
      local result = vim.fn.systemlist(find_command)

      assert.are.same(lines, result)
    end)
  end)

  describe("go", function()
    it("matches various import statements", function()
      local lines = {
        '\t"package"',
        'import "package"',
      }
      local file = io.open(test_file, "w")
      for _, line in ipairs(lines) do
        file:write(line .. "\n")
      end
      file:close()

      local find_command = string.format("rg --no-heading --no-line-number --color=never %s %s", vim.fn.shellescape(regex.go), test_file)
      local result = vim.fn.systemlist(find_command)

      assert.are.same(lines, result)
    end)
  end)

  describe("java", function()
    it("matches various import statements", function()
      local lines = {
        "import com.package.Class;",
        "import static com.package.Class.*;",
      }
      local file = io.open(test_file, "w")
      for _, line in ipairs(lines) do
        file:write(line .. "\n")
      end
      file:close()

      local find_command = string.format("rg --no-heading --no-line-number --color=never %s %s", vim.fn.shellescape(regex.java), test_file)
      local result = vim.fn.systemlist(find_command)

      assert.are.same(lines, result)
    end)
  end)

  describe("php", function()
    it("matches various use statements", function()
      local lines = {
        "use My\\Full\\Classname;",
        "use My\\Full\\Classname",
      }
      local file = io.open(test_file, "w")
      for _, line in ipairs(lines) do
        file:write(line .. "\n")
      end
      file:close()

      local find_command = string.format("rg --no-heading --no-line-number --color=never %s %s", vim.fn.shellescape(regex.php), test_file)
      local result = vim.fn.systemlist(find_command)

      assert.are.same(lines, result)
    end)
  end)

  describe("shell", function()
    it("matches various source statements", function()
      local lines = {
        "source file.sh",
      }
      local file = io.open(test_file, "w")
      for _, line in ipairs(lines) do
        file:write(line .. "\n")
      end
      file:close()

      local find_command = string.format("rg --no-heading --no-line-number --color=never %s %s", vim.fn.shellescape(regex.shell), test_file)
      local result = vim.fn.systemlist(find_command)

      assert.are.same(lines, result)
    end)
  end)

  describe("swift", function()
    it("matches various import statements", function()
      local lines = {
        "import Foundation",
      }
      local file = io.open(test_file, "w")
      for _, line in ipairs(lines) do
        file:write(line .. "\n")
      end
      file:close()

      local find_command = string.format("rg --no-heading --no-line-number --color=never %s %s", vim.fn.shellescape(regex.swift), test_file)
      local result = vim.fn.systemlist(find_command)

      assert.are.same(lines, result)
    end)
  end)
end)