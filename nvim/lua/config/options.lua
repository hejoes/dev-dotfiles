-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.maplocalleader = ","

vim.opt.conceallevel = 0
vim.opt.cmdheight = 0

-- Basic Settings
--  Settings for code not going ot of screen:
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true

vim.opt_local.cursorcolumn = true -- highlights the current column
vim.opt_local.shiftwidth = 2 -- Number of spaces to use for each step of (auto)indent
vim.opt_local.softtabstop = 2 -- Number of spaces that a <Tab> counts for while performing editing operations
vim.opt_local.tabstop = 2 -- Number of spaces that a <Tab> in the file counts for
vim.opt_local.expandtab = true -- Expand tab to 2 spaces

-- Folding with treesitter (supports all/most file types)
vim.opt_local.foldlevel = 1
vim.opt.foldcolumn = "0"

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

--  Compatiblness with avante.ai
vim.opt.laststatus = 3

vim.opt.hlsearch = false

-- Highlight matching brackets
vim.opt.showmatch = true
vim.opt.matchtime = 3
