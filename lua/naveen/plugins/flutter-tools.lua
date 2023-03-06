return {
  {
    'akinsho/flutter-tools.nvim',
    lazy = false,
    dev = true,
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'RobertBrunhage/flutter-riverpod-snippets', lazy = false },
    },
    config = function()
      local flutter = pcall(require, 'flutter-tools')
      if not flutter then
        return
      end

      require('flutter-tools').setup {
        -- deugger currently disable until dap are insralled for it' setup
        -- debugger = {
        -- enabled = true,
        -- run_via_dap = true,
        -- exception_breakpoints = {},
        -- },
        outline = { auto_open = false },
        decorations = {
          statusline = { device = true, app_version = true },
        },
        widget_guides = { enabled = true, debug = false },
        dev_log = { enabled = false, open_cmd = 'tabedit' },
        lsp = {
          color = {
            enabled = true,
            background = true,
            virtual_text = false,
          },
          settings = {
            showTodos = false,
            renameFilesWithClasses = 'prompt',
            updateImportsOnRename = true,
            completeFunctionCalls = true,
            lineLength = 100,
          },
        },
      }
    end,
  },
}
