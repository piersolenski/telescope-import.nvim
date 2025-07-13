local pickers = require("import.pickers")

local function validate_picker(picker)
  return pickers[picker] ~= nil
end

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
    custom_languages = {
      opts.custom_languages,
      function(value)
        if type(value) ~= "table" and value ~= nil then
          return false, "custom_languages must be a table or nil"
        end

        if value ~= nil then
          for i, lang in ipairs(value) do
            if type(lang) ~= "table" then
              return false, "custom_languages[" .. i .. "] must be a table"
            end
            local ok, err = pcall(validate_language, lang)
            if not ok then
              return false, "custom_languages[" .. i .. "]: " .. err
            end
          end
        end

        return true
      end,
    },
    insert_at_top = { opts.insert_at_top, { "boolean" } },
    picker = { opts.picker, validate_picker, "supported picker" },
  })
end

return validate_config
