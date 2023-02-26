require 'naveen.config.options'
require 'naveen.config.lazy'

-- autocmds and keymaps can wait to load
vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  callback = function()
    require 'naveen.config.autocmds'
    require 'naveen.config.keymaps'
  end,
})
