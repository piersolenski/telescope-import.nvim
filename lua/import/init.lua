local config = require("import.core.config")
local pick = require("import.commands.pick")

local M = {}

M.setup = config.setup

M.pick = pick

return M
