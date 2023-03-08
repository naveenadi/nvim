local swap_next, swap_prev = (function()
  local swap_objects = {
    p = '@parameter.inner',
    f = '@function.outer',
    c = '@class.outer',
  }

  local n, p = {}, {}
  for key, obj in pairs(swap_objects) do
    n[string.format('<leader>cx%s', key)] = obj
    p[string.format('<leader>cX%s', key)] = obj
  end

  return n, p
end)()

return {
  {
    'nvim-treesitter/nvim-treesitter',
    version = false, -- last release is way too old and doesn't work on Windows
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
      {
        'nvim-treesitter/nvim-treesitter-textobjects',
        init = function()
          -- PERF: no need to load the plugin, if we only need its queries for mini.ai
          local plugin = require('lazy.core.config').spec.plugins['nvim-treesitter']
          local opts = require('lazy.core.plugin').values(plugin, 'opts', false)
          local enabled = false
          if opts.textobjects then
            for _, mod in ipairs { 'move', 'select', 'swap', 'lsp_interop' } do
              if opts.textobjects[mod] and opts.textobjects[mod].enable then
                enabled = true
                break
              end
            end
          end
          if not enabled then
            require('lazy.core.loader').disable_rtp_plugin 'nvim-treesitter-textobjects'
          end
        end,
      },
    },
    keys = {
      { '<c-space>', desc = 'Increment selection' },
      { '<bs>', desc = 'Decrement selection', mode = 'x' },
    },
    ---@type TSConfig
    opts = {
      highlight = { enable = true },
      indent = { enable = true, disable = { 'python', 'yaml' } },
      context_commentstring = { enable = true, enable_autocmd = false },
      ensure_installed = {
        'bash',
        'dockerfile',
        'c',
        'help',
        'html',
        'javascript',
        'json',
        'lua',
        'luap',
        'markdown',
        'markdown_inline',
        'python',
        'query',
        'regex',
        'tsx',
        'typescript',
        'vim',
        'yaml',
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<C-space>',
          node_incremental = '<C-space>',
          scope_incremental = '<nop>',
          node_decremental = '<bs>',
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ['aa'] = '@parameter.outer',
            ['ia'] = '@parameter.inner',
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            [']m'] = '@function.outer',
            [']]'] = '@class.outer',
          },
          goto_next_end = {
            [']M'] = '@function.outer',
            [']['] = '@class.outer',
          },
          goto_previous_start = {
            ['[m'] = '@function.outer',
            ['[['] = '@class.outer',
          },
          goto_previous_end = {
            ['[M'] = '@function.outer',
            ['[]'] = '@class.outer',
          },
        },
        swap = {
          enable = true,
          swap_next = swap_next,
          swap_previous = swap_prev,
        },
      },
      matchup = {
        enable = true,
      },
      endwise = {
        enable = true,
      },
      autotag = {
        enable = true,
      },
    },
    ---@param opts TSConfig
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end,
  },

  -- surround
  --{
  --  'kylechui/nvim-surround',
  --  event = { 'BufReadPost', 'BufNewFile' },
  --  config = true,
  -- },
  {
    'echasnovski/mini.surround',
    --keys = function(_, keys)
    --  -- Populate the keys based on the user's options
    --  local plugin = require("lazy.core.config").spec.plugins["mini.surround"]
    --  local opts = require("lazy.core.plugin").values(plugin, "opts", false)
    --  local mappings = {
    --    { opts.mappings.add, desc = "Add surrounding", mode = { "n", "v" } },
    --    { opts.mappings.delete, desc = "Delete surrounding" },
    --    { opts.mappings.find, desc = "Find right surrounding" },
    --    { opts.mappings.find_left, desc = "Find left surrounding" },
    --    { opts.mappings.highlight, desc = "Highlight surrounding" },
    --    { opts.mappings.replace, desc = "Replace surrounding" },
    --    { opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
    --  }
    --  mappings = vim.tbl_filter(function(m)
    --    return m[1] and #m[1] > 0
    --  end, mappings)
    --  return vim.list_extend(mappings, keys)
    -- end,
    -- opts = {
    --  mappings = {
    --    add = "gza", -- Add surrounding in Normal and Visual modes
    --    delete = "gzd", -- Delete surrounding
    --    find = "gzf", -- Find surrounding (to the right)
    --     find_left = "gzF", -- Find surrounding (to the left)
    --    highlight = "gzh", -- Highlight surrounding
    --    replace = "gzr", -- Replace surrounding
    --    update_n_lines = "gzn", -- Update `n_lines`
    --   },
    --  },
    config = function(_, opts)
      -- use gz mappings instead of s to prevent conflict with leap
      require('mini.surround').setup(opts)
    end,
  },

  -- Highlight arguments'
  {
    'm-demare/hlargs.nvim',
    event = 'VeryLazy',
    opts = {
      color = '#ef9062',
      use_colorpalette = false,
      disable = function(_, bufnr)
        if vim.b.semantic_tokens then
          return true
        end
        local clients = vim.lsp.get_active_clients { bufnr = bufnr }
        for _, c in pairs(clients) do
          local caps = c.server_capabilities
          if c.name ~= 'null-ls' and caps.semanticTokensProvider and caps.semanticTokensProvider.full then
            vim.b.semantic_tokens = true
            return vim.b.semantic_tokens
          end
        end
      end,
    },
  },

  -- dims inactive portions
  {
    'folke/twilight.nvim',
    config = function()
      require('twilight').setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end,
  },
}
