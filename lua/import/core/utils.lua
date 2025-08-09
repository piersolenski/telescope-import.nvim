local M = {}

M.get_filetype = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local filetype = vim.bo[bufnr].filetype
  return filetype
end

M.remove_duplicates = function(inputTable)
  local uniqueTable = {}
  local resultTable = {}

  for _, value in ipairs(inputTable) do
    if not uniqueTable[value] then
      uniqueTable[value] = true
      table.insert(resultTable, value)
    end
  end

  return resultTable
end

M.remove_entries = function(source_table, table_to_remove)
  local lookup = {}
  for _, value in ipairs(table_to_remove) do
    lookup[value] = true
  end
  local new_table = {}
  for _, value in ipairs(source_table) do
    if not lookup[value] then
      table.insert(new_table, value)
    end
  end
  return new_table
end

M.sort_by_frequency = function(inputTable)
  local frequencies = {}

  -- Count the frequencies of elements in the input table
  for _, value in ipairs(inputTable) do
    frequencies[value] = (frequencies[value] or 0) + 1
  end

  -- Create a table with pairs of elements and their frequencies
  local elementsAndFrequencies = {}
  for element, frequency in pairs(frequencies) do
    table.insert(elementsAndFrequencies, { element = element, frequency = frequency })
  end

  -- Sort the table based on frequencies in descending order
  table.sort(elementsAndFrequencies, function(a, b)
    return a.frequency > b.frequency
  end)

  local sortedTable = {}
  for _, pair in ipairs(elementsAndFrequencies) do
    for _ = 1, pair.frequency do
      table.insert(sortedTable, pair.element)
    end
  end

  return sortedTable
end

M.concat_tables = function(t1, t2)
  for i = 1, #t2 do
    t1[#t1 + 1] = t2[i]
  end
  return t1
end

local function lists_have_overlap(list_a, list_b)
  if type(list_a) ~= "table" or type(list_b) ~= "table" then
    return false
  end
  local values = {}
  for _, value in ipairs(list_a) do
    values[value] = true
  end
  for _, value in ipairs(list_b) do
    if values[value] then
      return true
    end
  end
  return false
end

-- Deep merge language configs so that custom languages override defaults
-- when their filetype lists overlap. New custom entries are appended.
-- merge_language_configs removed; simpler precedence is applied at call site

return M
