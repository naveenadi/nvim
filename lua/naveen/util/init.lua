local Util = require 'lazy.core.util'

local M = {}

M.root_patterns = { '.git', 'lua' }

---@param on_attach fun(client, buffer)
function M.on_attach(on_attach)
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, buffer)
    end,
  })
end

---@param plugin string
function M.has(plugin)
  return require('lazy.core.config').plugins[plugin] ~= nil
end

---@param fn fun()
function M.on_very_lazy(fn)
  vim.api.nvim_create_autocmd('User', {
    pattern = 'VeryLazy',
    callback = function()
      fn()
    end,
  })
end

---@param name string
function M.opts(name)
  local plugin = require('lazy.core.config').plugins[name]
  if not plugin then
    return {}
  end
  local Plugin = require 'lazy.core.plugin'
  return Plugin.values(plugin, 'opts', false)
end

-- FIXME: create a togglable terminal
-- Opens a floating terminal (interactive by default)
---@param cmd? string[]|string
---@param opts? LazyCmdOptions|{interactive?:boolean}
function M.float_term(cmd, opts)
  opts = vim.tbl_deep_extend('force', {
    size = { width = 0.9, height = 0.9 },
  }, opts or {})
  require('lazy.util').float_term(cmd, opts)
end

---@param silent boolean?
---@param values? {[1]:any, [2]:any}
function M.toggle(option, silent, values)
  if values then
    if vim.opt_local[option]:get() == values[1] then
      vim.opt_local[option] = values[2]
    else
      vim.opt_local[option] = values[1]
    end
    return Util.info('Set ' .. option .. ' to ' .. vim.opt_local[option]:get(), { title = 'Option' })
  end
  vim.opt_local[option] = not vim.opt_local[option]:get()
  if not silent then
    if vim.opt_local[option]:get() then
      Util.info('Enabled ' .. option, { title = 'Option' })
    else
      Util.warn('Disabled ' .. option, { title = 'Option' })
    end
  end
end

local enabled = true
function M.toggle_diagnostics()
  enabled = not enabled
  if enabled then
    vim.diagnostic.enable()
    Util.info('Enabled diagnostics', { title = 'Diagnostics' })
  else
    vim.diagnostic.disable()
    Util.warn('Disabled diagnostics', { title = 'Diagnostics' })
  end
end

function M.deprecate(old, new)
  Util.warn(('`%s` is deprecated. Please use `%s` instead'):format(old, new), { title = 'LazyVim' })
end

-- delay notifications till vim.notify was replaced or after 500ms
function M.lazy_notify()
  local notifs = {}
  local function temp(...)
    table.insert(notifs, vim.F.pack_len(...))
  end

  local orig = vim.notify
  vim.notify = temp

  local timer = vim.loop.new_timer()
  local check = vim.loop.new_check()

  local replay = function()
    timer:stop()
    check:stop()
    if vim.notify == temp then
      vim.notify = orig -- put back the original notify if needed
    end
    vim.schedule(function()
      ---@diagnostic disable-next-line: no-unknown
      for _, notif in ipairs(notifs) do
        vim.notify(vim.F.unpack_len(notif))
      end
    end)
  end

  -- wait till vim.notify has been replaced
  check:start(function()
    if vim.notify ~= temp then
      replay()
    end
  end)
  -- or if it took more than 500ms, then something went wrong
  timer:start(500, 0, replay)
end

function M.quit()
  local bufnr = vim.api.nvim_get_current_buf()
  local buf_windows = vim.call('win_findbuf', bufnr)
  local modified = vim.api.nvim_buf_get_option(bufnr, 'modified')
  if modified and #buf_windows == 1 then
    vim.ui.input({
      prompt = 'You have unsaved changes. Quit anyway? (y/n) ',
    }, function(input)
      if input == 'y' then
        vim.cmd 'qa!'
      end
    end)
  else
    vim.cmd 'qa!'
  end
end

function M.find_files()
  local opts = {}
  local telescope = require 'telescope.builtin'

  local ok = pcall(telescope.git_files, opts)
  if not ok then
    telescope.find_files(opts)
  end
end

return M
