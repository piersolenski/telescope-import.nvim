local M = {}

M.removeDuplicates = function(inputTable)
  local uniqueTable = {}

  for _, value in ipairs(inputTable) do
    if not uniqueTable[value] then
      uniqueTable[value] = true
    end
  end

  local resultTable = {}
  for key, _ in pairs(uniqueTable) do
    table.insert(resultTable, key)
  end

  return resultTable
end

return M
