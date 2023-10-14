-- set leader key to space
vim.g.mapleader = " "

local Remap = require("naveen.core.helpers.keymap_util")
local nnoremap = Remap.nnoremap
local inoremap = Remap.inoremap
local xnoremap = Remap.xnoremap
local tnoremap = Remap.tnoremap

local silent = { silent = true }


---------------------
-- General Keymaps -------------------

-- easier to enter normal mode
inoremap("jk", "<Esc>", { desc = "Exit insert mode with jk" })

-- clear search highlights
nnoremap("<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- delete single character without copying into register
-- nnoremap("x", '"_x')

-- increment/decrement numbers
nnoremap("<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
nnoremap("<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
nnoremap("<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
nnoremap("<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
nnoremap("<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
nnoremap("<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

nnoremap("<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
nnoremap("<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
nnoremap("<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
nnoremap("<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
nnoremap("<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- Movement
nnoremap("<C-L>", "<C-W><C-L>")
nnoremap("<C-H>", "<C-W><C-H>")
nnoremap("<C-K>", "<C-W><C-K>")
nnoremap("<C-J>", "<C-W><C-J>")
nnoremap("<C-d>", "<C-d>zz")
nnoremap("<C-u>", "<C-u>zz")
nnoremap("n", "nzzzv")
nnoremap("N", "Nzzzv")
xnoremap(
  "n",
  [[:<c-u>let temp_variable=@"<CR>gvy:<c-u>let @/='\V<C-R>=escape(@",'/\')<CR>'<CR>:let @"=temp_variable<CR>]],
  silent
)

-- Copy Paste
xnoremap("<leader>y", "\"+y", silent)

-- built in terminal
nnoremap("<leader>t", "<Cmd>sp<CR> <Cmd>term<CR> <Cmd>resize 20N<CR> i", silent)
tnoremap("<C-c><C-c>", "<C-\\><C-n>", silent)
tnoremap("<D-v>", function()
  local keys = vim.api.nvim_replace_termcodes("<C-\\><C-n>\"+pi", true, false, true)
  vim.api.nvim_feedkeys(keys, "n", false)
end, silent)

-- writing
nnoremap("<C-s>", "<Cmd>set spell!<CR>", silent)

-- misc
nnoremap("<leader>rp", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")
nnoremap("<leader>w", "<Cmd>w<CR>")
nnoremap("<leader>q", "<Cmd>q<CR>")
nnoremap("<leader><C-o>", "<Cmd>!open %<CR><CR>", silent)
nnoremap("J", "mzJ`z")
xnoremap("J", "mzJ`z")

-- Running Code
-- nnoremap("<leader>cb", "<Cmd>Build<CR>", silent)
-- nnoremap("<leader>cd", "<Cmd>DebugBuild<CR>", silent)
-- nnoremap("<leader>cl", "<Cmd>Run<CR>", silent)
-- nnoremap("<leader>cr", "<Cmd>Ha<CR>", silent)
