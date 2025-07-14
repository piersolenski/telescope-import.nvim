---@module 'luassert'

local import = require("import")

describe("Setup", function()
  it("accepts valid config", function()
    import.setup({
      insert_at_top = true,
    })
  end)

  it("rejects an invalid config", function()
    assert.error_matches(function()
      import.setup({
        insert_at_top = "bananas",
      })
    end, "insert_at_top: expected boolean, got string")
  end)
end)
