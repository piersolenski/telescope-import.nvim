local function validate_language(lang)
  vim.validate({
    extensions = { lang.extensions, "table" },
    filetypes = { lang.filetypes, "table" },
    regex = { lang.regex, "string" },
    insert_at_line = { lang.insert_at_line, { "nil", "number", "function" }, true },
  })

  for _, ext in ipairs(lang.extensions) do
    vim.validate({ extension = { ext, "string" } })
  end

  for _, ft in ipairs(lang.filetypes) do
    vim.validate({ filetype = { ft, "string" } })
  end
end

local function validate_config(opts)
  vim.validate({
    insert_at_top = { opts.insert_at_top, { "boolean" } },
    custom_languages = {
      opts.custom_languages,
      function(value)
        if type(value) ~= "table" and value ~= nil then
          return false, "custom_languages must be a table or nil"
        end

        if value ~= nil then
          for _, lang in ipairs(value) do
            if type(lang) ~= "table" then
              return false, "each item in custom_languages must be a table"
            end
            local ok, err = pcall(validate_language, lang)
            if not ok then
              return false, err
            end
          end
        end

        return true
      end,
    },
  })
end

return validate_config
