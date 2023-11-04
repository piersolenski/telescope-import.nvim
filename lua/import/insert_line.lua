local function insert_line(value, insert_at_top)
  local original_position

  if insert_at_top then
    original_position = vim.fn.getpos(".")
    vim.cmd("normal! gg")
  end

  vim.api.nvim_put({ value }, "l", false, false)

  if insert_at_top then
    vim.fn.setpos(".", original_position)
  end
end

return insert_line
