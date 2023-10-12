local options = {
  autoindent = true, -- copy indent from current line when starting new one
  smartindent = true, -- Turn on smart indentation. See in the docs for more info
  tabstop = 2, -- 2 spaces for tabs (prettier default)
  shiftwidth = 2, -- 2 spaces for indent width
  expandtab = true, -- expand tab to spaces
  showtabline = 0,

  -- line numbers
  number = true, -- show absolute line number on cursor line (when relative number is on)
  relativenumber = true, -- show relative line number

  numberwidth = 4,

  incsearch = true,
  hlsearch = false,
  -- search settings
  ignorecase = true, -- ignore case when searching
  smartcase = true, -- if you include mixed case in your search, assumes you want case-sensitive
  showmatch = true, -- Highlight search instances
  joinspaces = false, -- Join multiple spaces in search

  -- split windows
  splitbelow = true, -- split horizontal window to the bottom
  splitright = true, -- split vertical window to the right

  -- Wild Menu 
  wildmenu = true,
  wildmode = "longest:full,full",

  termguicolors = true,
  hidden = true,
  background = "dark", -- colorschemes that can be light or dark will be made dark
  signcolumn = "yes", -- show sign column so that text doesn't shift
  showmode = false,
  errorbells = false,

  -- line wrapping
  wrap = false, -- disable line wrapping 

  -- cursor line
  cursorline = true, -- highlight the current cursor line
  fileencoding = "utf-8",

  backup = false,
  writebackup = false,
  swapfile = false,
  undodir = os.getenv("HOME") .. "/.vim/undodir",
  undofile = true,

  colorcolumn = "80",
  updatetime = 20,
  scrolloff = 15,
  mouse = "a",
  guicursor = "a:block",

  title = true,
  -- titlestring = "%t - Wvim",
  titlestring = "Neovim - %t",
  guifont = "MesloLGS NF:h18",

  -- backspace
  backspace = "indent,eol,start", -- allow backspace on indent, end of line or insert mode start position

  -- clipboard
  clipboard = "unnamedplus", -- use system clipboard as default register
  fixeol = false, -- Turn off appending new line in the end of a file

  -- Folding
  foldmethod = 'syntax',
}
-- vim.opt.nrformats:append("alpha") -- increment letters
vim.opt.shortmess:append("IsF")

-- vim.o.shortmess = "filnxstToOFS"

for option, value in pairs(options) do
  vim.opt[option] = value
end

-- Default Plugins {{{
local disabled_built_ins = {
  "netrw",
  "netrwPlugin",
  "netrwSettings",
  "netrwFileHandlers",
  "gzip",
  "zip",
  "zipPlugin",
  "tar",
  "tarPlugin",
  "getscript",
  "getscriptPlugin",
  "vimball",
  "vimballPlugin",
  "2html_plugin",
  "logipat",
  "rrhelper",
  "spellfile_plugin",
  "matchit"
}

for _, plugin in pairs(disabled_built_ins) do
  vim.g["loaded_" .. plugin] = 1
end
