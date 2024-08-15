local function validate_config(opts)
  return vim.validate({
    insert_at_line = { opts.insert_at_line, { "nil", "number", "function" } },
    custom_languages = {
      opts.custom_languages,
      function(value)
        if type(value) ~= "table" and value ~= nil then
          return false, "custom_languages must be a table or nil"
        end
        for _, lang in ipairs(value or {}) do
          if type(lang) ~= "table" then
            return false, "each item in custom_languages must be a table"
          end
          -- Ensure that extensions, filetypes, and regex are always present and correctly formatted
          if
            not (
              type(lang.extensions) == "table"
              and type(lang.filetypes) == "table"
              and type(lang.regex) == "string"
            )
          then
            return false,
              "extensions, filetypes, and regex are all required fields with proper structure in each language table"
          end

          for _, ext in ipairs(lang.extensions) do
            if type(ext) ~= "string" then
              return false, "all extensions should be strings"
            end
          end

          for _, ft in ipairs(lang.filetypes) do
            if type(ft) ~= "string" then
              return false, "all filetypes should be strings"
            end
          end

          -- Optional validation for insert_at_line
          if lang.insert_at_line and type(lang.insert_at_line) ~= "number" then
            return false, "insert_at_line must be a number if provided"
          end
        end
        return true
      end,
    },
  })
end

return validate_config
