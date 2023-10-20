local Remap = require("naveen.core.helpers.keymap_util")
local inoremap = Remap.inoremap
local nnoremap = Remap.nnoremap
local vnoremap = Remap.vnoremap

return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    --"hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
  },
  config = function ()
    -- import lspconfig plugin
    local lspconfig = require("lspconfig")

    -- import cmp-nvim-lsp plugin
    --local cmp_nvim_lsp = require("cmp_nvim_lsp")

    local on_attach = function (client, buhnr)
      -- lsp.default_keymaps({ buffer = bufnr })
      local opts = { buffer = bufnr, silent = true }

      -- set keybinds
      opts.desc = "See available code actions"
      nnoremap("<leader>ca", function() vim.lsp.buf.code_action() end, opts)
      vnoremap("<leader>ca", function() vim.lsp.buf.code_action() end, opts) -- see available code actions, in visual mode will apply to selection
      opts.desc = "Smart rename"
      nnoremap("<leader>rn", function() vim.lsp.buf.rename() end, opts)
      opts.desc = "Show LSP implementations"
      nnoremap("gi", function() vim.lsp.buf.implementation() end, opts)
      opts.desc = "Show LSP references"
      nnoremap("gR", function() vim.lsp.buf.references() end, opts) -- show definition, references
      opts.desc = "Show LSP definitions"
      nnoremap("gd", function() vim.lsp.buf.definition() end, opts)
      opts.desc = "Go to declaration"
      nnoremap("gD", function() vim.lsp.buf.declaration() end, opts)
      opts.desc = "Show documentation for what is under cursor"
      nnoremap("K", function() vim.lsp.buf.hover() end, opts)
      inoremap("<C-K>", function() vim.lsp.buf.signature_help() end, opts)
    end

    -- used to enable autocompletion (assign to every lsp server config)
    -- local capabilities = cmp_nvim_lsp.default_capabilities()
    local capabilities = vim.lsp.protocol.make_client_capabilities()

    -- Change the Diagnostic symbols in the sign column (gutter)
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    -- Enable some language servers with the additional completion capabilities offered by nvim-cmp
    local servers = { 'clangd', 'rust_analyzer', 'pyright', 'tsserver' }
    for _, lsp in ipairs(servers) do
      lspconfig[lsp].setup {
        on_attach = on_attach,
        capabilities = capabilities,
      }
    end

    -- configure lua server (with special settings)
    lspconfig["lua_ls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = { -- custom settings for lua
        Lua = {
          -- make the language server recognize "vim" global
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            -- make language server aware of runtime files
            library = {
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.stdpath("config") .. "/lua"] = true,
            },
          },
        },
      },
    })
  end,
}
