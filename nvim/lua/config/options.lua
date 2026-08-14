-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.maplocalleader = ","

-- Off by default; toggle on ad hoc with <leader>uf (global) / <leader>uF (buffer)
vim.g.autoformat = false

-- Use snacks.picker as the single default fuzzy picker (LazyVim routes all its
-- pickers through this). telescope stays installed for the custom Helm values
-- picker (<leader>hv) and the terraform telescope extensions; fzf-lua is dropped
-- (see lua/plugins/editor/picker.lua).
vim.g.lazyvim_picker = "snacks"

vim.opt.conceallevel = 0
vim.opt.cmdheight = 0

-- Basic Settings
--  Settings for code not going ot of screen:
vim.opt.wrap = true
vim.opt.breakindent = true

vim.opt.cursorcolumn = true -- highlights the current column
vim.opt.softtabstop = 2 -- Number of spaces that a <Tab> counts for while performing editing operations

-- Folding with treesitter (supports all/most file types)
-- Folds are NEVER auto-closed: files always open fully expanded so you don't
-- have to `zR` all the time. foldenable=false keeps everything open; the high
-- foldlevel values are a safety net so nothing collapses even if a `zc`/`za`
-- toggles foldenable back on. Folding still works manually if you ever want it.
vim.opt.foldenable = false
vim.opt.foldlevelstart = 99
vim.opt.foldcolumn = "0"

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

vim.opt.hlsearch = false

-- Highlight matching brackets
vim.opt.showmatch = true
vim.opt.matchtime = 3

-- Paste performance optimization
-- These settings help prevent freezing when pasting large content, especially in WezTerm
vim.opt.timeoutlen = 500 -- Time in ms to wait for a mapped sequence to complete
vim.opt.ttimeoutlen = 10 -- Time in ms to wait for a key code sequence to complete

-- Improve paste performance by reducing update frequency during paste
vim.opt.updatetime = 100 -- Faster completion and better paste performance
