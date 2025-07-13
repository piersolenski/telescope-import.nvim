---@module 'luassert'

local regex = require("import.regex")

describe("Regex with rg", function()
  local test_file = "test_imports.js"

  after_each(function()
    os.remove(test_file)
  end)

  local function test_language_imports(language, expected_lines)
    local file = io.open(test_file, "w")
    if file then
      for _, line in ipairs(expected_lines) do
        file:write(line .. "\n")
      end
      file:close()
    end

    local find_command = string.format(
      "rg --no-heading --no-line-number --color=never %s %s",
      vim.fn.shellescape(regex[language]),
      test_file
    )
    local result = vim.fn.systemlist(find_command)

    assert.are.same(expected_lines, result)
  end

  describe("javascript", function()
    it("matches various import statements", function()
      local lines = {
        "import package from 'package';",
        'import { method } from "package";',
        "import { method as myMethod } from 'package';",
        "import * as package from 'package';",
      }
      test_language_imports("javascript", lines)
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
      test_language_imports("python", lines)
    end)
  end)

  describe("lua", function()
    it("matches various require statements", function()
      local lines = {
        "local package = require('package')",
        'local package = require("package")',
      }
      test_language_imports("lua", lines)
    end)
  end)

  describe("c", function()
    it("matches various include statements", function()
      local lines = {
        '#include "package.h"',
        "#include <package.h>",
      }
      test_language_imports("c", lines)
    end)
  end)

  describe("go", function()
    it("matches various import statements", function()
      local lines = {
        '\t"package"',
        'import "package"',
      }
      test_language_imports("go", lines)
    end)
  end)

  describe("java", function()
    it("matches various import statements", function()
      local lines = {
        "import com.package.Class;",
        "import static com.package.Class.*;",
      }
      test_language_imports("java", lines)
    end)
  end)

  describe("php", function()
    it("matches various use statements", function()
      local lines = {
        "use My\\Full\\Classname;",
        "use My\\Full\\Classname",
      }
      test_language_imports("php", lines)
    end)
  end)

  describe("shell", function()
    it("matches various source statements", function()
      local lines = {
        "source file.sh",
      }
      test_language_imports("shell", lines)
    end)
  end)

  describe("swift", function()
    it("matches various import statements", function()
      local lines = {
        "import Foundation",
      }
      test_language_imports("swift", lines)
    end)
  end)
end)
