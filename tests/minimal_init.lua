local function clone_repo(repo_url, dest_dir)
  if vim.fn.isdirectory(dest_dir) == 0 then
    vim.fn.system({ "git", "clone", repo_url, dest_dir })
  end
end

local repos = {
  {
    url = "https://github.com/nvim-lua/plenary.nvim",
    dir = os.getenv("PLENARY_DIR") or "/tmp/plenary.nvim",
    plugin = "plenary",
  },
  {
    url = "https://github.com/nvim-telescope/telescope.nvim",
    dir = os.getenv("telescope_DIR") or "/tmp/telescope.nvim",
    plugin = "telescope",
  },
  {
    url = "https://github.com/folke/snacks.nvim/",
    dir = os.getenv("snacks_DIR") or "/tmp/snacks.nvim",
    plugin = "snacks",
  },
  {
    url = "https://github.com/ibhagwan/fzf-lua",
    dir = os.getenv("fzf-lua_DIR") or "/tmp/fzf-lua.nvim",
    plugin = "fzf-lua",
  },
}

-- Clone repositories
for _, repo in ipairs(repos) do
  clone_repo(repo.url, repo.dir)
end

vim.opt.swapfile = false
vim.opt.rtp:append(".")

-- Add to runtime path
for _, repo in ipairs(repos) do
  vim.opt.rtp:append(repo.dir)
end

-- Load runtime files
for _, repo in ipairs(repos) do
  vim.cmd.runtime({ "plugin/" .. repo.plugin .. ".vim" })
end

require("plenary.busted")
