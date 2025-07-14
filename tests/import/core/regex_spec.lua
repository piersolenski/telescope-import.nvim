---@module 'luassert'

local constants = require("import.core.constants")
local regex = require("import.language.regex")

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

    local flags = table.concat(constants.rg_flags, " ")
    local find_command =
      string.format("rg %s %s %s", flags, vim.fn.shellescape(regex[language]), test_file)
    local result = vim.fn.systemlist(find_command)

    assert.are.same(expected_lines, result)
  end

  local language_tests = {
    {
      name = "c",
      description = "matches various include statements",
      lines = {
        '#include "package.h"',
        "#include <package.h>",
      },
    },
    {
      name = "go",
      description = "matches various import statements",
      lines = {
        '\t"package"',
        'import "package"',
      },
    },
    {
      name = "java",
      description = "matches various import statements",
      lines = {
        "import com.package.Class;",
        "import static com.package.Class.*;",
      },
    },
    {
      name = "javascript",
      description = "matches various import statements",
      lines = {
        "import package from 'package';",
        'import { method } from "package";',
        "import { method as myMethod } from 'package';",
        "import * as package from 'package';",
      },
    },
    {
      name = "lua",
      description = "matches various require statements",
      lines = {
        "local package = require('package')",
        'local package = require("package")',
      },
    },
    {
      name = "php",
      description = "matches various use statements",
      lines = {
        "use My\\Full\\Classname;",
        "use My\\Full\\Classname",
      },
    },
    {
      name = "python",
      description = "matches various import statements",
      lines = {
        "import package",
        "from package import method",
        "from package import method1, method2",
        "from package import method as myMethod",
      },
    },
    {
      name = "ruby",
      description = "matches various import statements",
      lines = {
        "require 'json'",
        "require 'net/http'",
        "require_relative '../models/user'",
        "require json",
      },
    },
    {
      name = "shell",
      description = "matches various source statements",
      lines = {
        "source file.sh",
      },
    },
    {
      name = "swift",
      description = "matches various import statements",
      lines = {
        "import Foundation",
      },
    },
  }

  for _, test_data in ipairs(language_tests) do
    describe(test_data.name, function()
      it(test_data.description, function()
        test_language_imports(test_data.name, test_data.lines)
      end)
    end)
  end
end)
