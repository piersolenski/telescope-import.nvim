local function get_filetype_config(languages, filetype)
  for _, config in ipairs(languages) do
    for _, current_filetype in ipairs(config.filetypes) do
      if current_filetype == filetype then
        return config
      end
    end
  end
  return nil
end

return get_filetype_config
