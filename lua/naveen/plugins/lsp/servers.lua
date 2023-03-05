local M = {}

local lsp_util = require 'naveen.plugins.lsp.util'
local icons = require 'naveen.config.icons'

local function lsp_init()
  -- diagnostics
  local signs = {
    { name = 'DiagnosticSignError', text = icons.diagnostics.Error },
    { name = 'DiagnosticSignWarn', text = icons.diagnostics.Warning },
    { name = 'DiagnosticSignHint', text = icons.diagnostics.Hint },
    { name = 'DiagnosticSignInfo', text = icons.diagnostics.Info },
  }
  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
  end

  -- LSP handlers configuration
  local config = {
    float = {
      focusable = true,
      style = 'minimal',
      border = 'rounded',
    },

    -- options for vim.diagnostic.config()
    diagnostic = {
      -- virtual_text = false,
      -- virtual_text = { spacing = 4, prefix = "●" },
      virtual_text = {
        severity = {
          min = vim.diagnostic.severity.ERROR,
        },
      },
      signs = {
        active = signs,
      },
      underline = false,
      update_in_insert = false,
      severity_sort = true,
      float = {
        focusable = true,
        style = 'minimal',
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = '',
      },
      -- virtual_lines = true,
    },
  }

  -- Diagnostic configuration
  vim.diagnostic.config(config.diagnostic)

  -- Hover configuration
  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, config.float)

  -- Signature help configuration
  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, config.float)
end

function M.setup(_, opts)
  -- setup autoformat
  require('naveen.plugins.lsp.format').autoformat = opts.autoformat
  -- setup formatting and keymaps
  lsp_util.on_attach(function(client, buffer)
    require('naveen.plugins.lsp.format').on_attach(client, buffer)
    require('naveen.plugins.lsp.keymaps').on_attach(client, buffer)
  end)

  lsp_init() -- diagnostics, handlers

  local servers = opts.servers
  local capabilities = lsp_util.capabilities()
  local function setup(server)
    local server_opts = vim.tbl_deep_extend('force', {
      capabilities = vim.deepcopy(capabilities),
    }, servers[server] or {})

    if opts.setup[server] then
      if opts.setup[server](server, server_opts) then
        return
      end
    elseif opts.setup['*'] then
      if opts.setup['*'](server, server_opts) then
        return
      end
    end
    require('lspconfig')[server].setup(server_opts)
  end

  -- temp fix for lspconfig rename
  -- https://github.com/neovim/nvim-lspconfig/pull/2439
  local mappings = require 'mason-lspconfig.mappings.server'
  if not mappings.lspconfig_to_package.lua_ls then
    mappings.lspconfig_to_package.lua_ls = 'lua-language-server'
    mappings.package_to_lspconfig['lua-language-server'] = 'lua_ls'
  end

  local mlsp = require 'mason-lspconfig'
  local available = mlsp.get_available_servers()

  local ensure_installed = {} ---@type string[]
  for server, server_opts in pairs(servers) do
    if server_opts then
      server_opts = server_opts == true and {} or server_opts
      -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
      if server_opts.mason == false or not vim.tbl_contains(available, server) then
        setup(server)
      else
        ensure_installed[#ensure_installed + 1] = server
      end
    end
  end

  require('mason-lspconfig').setup { ensure_installed = ensure_installed }
  require('mason-lspconfig').setup_handlers { setup }
end

return M
