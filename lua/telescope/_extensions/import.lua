local actions = require("telescope.actions")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local conf = require("telescope.config").values
local action_state = require("telescope.actions.state")
local utils = require("import.utils")

local function debug(obj)
  local function dump(o)
    if type(o) == "table" then
      local s = "{ "
      for k, v in pairs(o) do
        if type(k) ~= "number" then
          k = '"' .. k .. '"'
        end
        s = s .. "[" .. k .. "] = " .. dump(v) .. ","
      end
      return s .. "} "
    else
      return tostring(o)
    end
  end
  print(dump(obj))
end

local filetypes = {
  {
    regex = [["^(?:import(?:[\"'\s]*([\w*{}\n, ]+)from\s*)?[\"'\s]*([@\w/_-]+)[\"'\s].*)"]],
    rg_types = { "js", "ts" },
  },
}

local function get_imports()
  local pattern = [["^(?:import(?:[\"'\s]*([\w*{}\n, ]+)from\s*)?[\"'\s]*([@\w/_-]+)[\"'\s].*)"]]

  local find_command = "rg -t js -t ts --no-heading --no-line-number --color=never --no-filename "
    .. pattern
  local results = vim.fn.systemlist(find_command)
  debug(results)
  results = utils.removeDuplicates(results)

  local total = {}

  for _, result in ipairs(results) do
    table.insert(total, { name = result })
  end

  return total
end

local function search(opts)
  -- List of predefined colors
  local colors = get_imports()
  pickers
    .new(opts, {
      prompt_title = "Emojis",
      sorter = conf.generic_sorter(opts),
      finder = finders.new_table({
        results = colors,
        entry_maker = function(color)
          return {
            value = color.name,
            display = color.name,
            ordinal = color.name,
          }
        end,
      }),
      attach_mappings = function(prompt_bufnr, _)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          local penis = selection.value
          vim.api.nvim_put({ penis }, "l", false, false)
        end)
        return true
      end,
    })
    :find()
end

return require("telescope").register_extension({
  exports = { import = search },
})
