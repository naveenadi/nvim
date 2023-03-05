return {
  -- cmdline tools and lsp servers
  {
    'williamboman/mason.nvim',
    cmd = 'Mason',
    keys = { { '<leader>cm', '<cmd>Mason<cr> ' } },
    opts = {
      ensure_installed = {
        'stylua',
        'shellcheck',
        'shfmt',
        'flake8',
      },
    },

    ---@param opts MasonSettings | {ensure_installed: string[]}
    config = function(_, opts)
      require('mason').setup(opts)
      local mr = require 'mason-registry'
      for _, tool in ipairs(opts.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
    end,
  },

  -- lspconfig
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'folke/neoconf.nvim', cmd = 'Neoconf', config = true },
      { 'folke/neodev.nvim', opts = { experimental = { pathStrict = true } } },
      { 'j-hui/fidget.nvim', config = true },
      { 'smjonas/inc-rename.nvim', config = true },
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-nvim-lsp-signature-help',
        cond = function()
          return require('naveen.util').has 'nvim-cmp'
        end,
      },
    },
    ---@class PluginLspOpts
    opts = {
      -- Automatically format on save
      autoformat = true,
      -- options for vim.lsp.buf.format
      -- `bufnr` and `filter` is handled by the LazyVim formatter,
      -- but can be also overridden when specified
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
      -- LSP Server Settings
      ---@type lspconfig.options
      servers = {
        jsonls = {},
        lua_ls = {
          settings = {
            Lua = {
              completion = { callSnippet = 'Replace' },
              diagnostics = { globals = { 'vim' } },
              workspace = { checkThirdParty = false },
            },
          },
        },
        dockerls = {},
      },
      -- you can do any additional lsp server setup here
      -- return true if you don't want this server to be setup with lspconfig
      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
      setup = {
        -- example to setup with typescript.nvim
        -- tsserver = function(_, opts)
        --   require("typescript").setup({ server = opts })
        --   return true
        -- end,
        -- Specify * to use this function as a fallback for any server
        -- ["*"] = function(server, opts) end,
      },
    },
    ---@param opts PluginLspOpts
    config = function(plugin, opts)
      require('naveen.plugins.lsp.servers').setup(plugin, opts)
    end,
  },

  -- formatters
  {
    'jose-elias-alvarez/null-ls.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'mason.nvim' },
    opts = function()
      local nls = require 'null-ls'
      return {
        sources = {
          -- nls.builtins.formatting.prettierd,
          nls.builtins.formatting.stylua,
          nls.builtins.formatting.black,
          nls.builtins.diagnostics.ruff.with { extra_args = { '--max-line-length=180' } },
        },
      }
    end,
  },
}
