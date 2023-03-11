--- Install lazy.nvim
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- Configure lazy.nvim
require('lazy').setup {
  spec = {
    { import = 'naveen.plugins' },
    { import = 'naveen.plugins.extras.lang' },
    -- { import = "naveen.plugins.extras.ui" },
    { import = 'naveen.plugins.extras.pde' },
    { import = 'naveen.plugins.extras.pde.notes' },
  },
  defaults = { lazy = true, version = nil },
  install = { missing = true, colorscheme = { 'tokyonight', 'gruvbox' } },
  checker = { enabled = true },
  performance = {
    cache = {
      enabled = true,
    },
    rtp = {
      disabled_plugins = {
        'gzip',
        'matchit',
        'matchparen',
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
}
-- vim.keymap.set('n', '<leader>zz', '<cmd>:Lazy<cr>', { desc = 'Manage Plugins' })
