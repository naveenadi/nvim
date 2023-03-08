return {
  {
    'iamcco/markdown-preview.nvim',
    ft = { 'markdown' },
    build = 'cd app && npm install',
    init = function()
      vim.g.mkdp_filetypes = { 'markdown' }
    end,
  },
  { 'AckslD/nvim-FeMaco.lua', ft = { 'markdown' }, opts = {} },

  -- { "toppair/peek.nvim", build = "deno task --quiet build:fast" },
  -- {"ellisonleao/glow.nvim", config = true, cmd = "Glow"}
}
