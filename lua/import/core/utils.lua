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
  local result = {}
  -- Copy first table
  for i = 1, #t1 do
    result[i] = t1[i]
  end
  -- Append second table
  for i = 1, #t2 do
    result[#result + 1] = t2[i]
  end
  return result
end

return M
