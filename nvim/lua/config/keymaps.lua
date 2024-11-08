-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymap = vim.keymap
local opts = { noremap = true, silent = true }
local Util = require("lazyvim.util")

keymap.set("n", "<C-h>", "<Cmd>NvimTmuxNavigateLeft<CR>", { silent = true })
keymap.set("n", "<C-j>", "<Cmd>NvimTmuxNavigateDown<CR>", { silent = true })
keymap.set("n", "<C-k>", "<Cmd>NvimTmuxNavigateUp<CR>", { silent = true })
keymap.set("n", "<C-l>", "<Cmd>NvimTmuxNavigateRight<CR>", { silent = true })
keymap.set("n", "<C-\\>", "<Cmd>NvimTmuxNavigateLastActive<CR>", { silent = true })
keymap.set("n", "<C-Space>", "<Cmd>NvimTmuxNavigateNavigateNext<CR>", { silent = true })

-- Borderless lazygit
vim.keymap.set("n", "<leader>gg", function()
  Util.terminal({ "lazygit" }, { cwd = Util.root(), esc_esc = false, ctrl_hjkl = false, border = "none" })
end, { desc = "Lazygit (root dir)" })

keymap.del({ "n", "i", "v" }, "<A-j>")
keymap.del({ "n", "i", "v" }, "<A-k>")
keymap.del("n", "<C-Left>")
keymap.del("n", "<C-Down>")
keymap.del("n", "<C-Up>")
keymap.del("n", "<C-Right>")

keymap.set("n", "<M-h>", '<Cmd>lua require("tmux").resize_left()<CR>', { silent = true })
keymap.set("n", "<M-j>", '<Cmd>lua require("tmux").resize_bottom()<CR>', { silent = true })
keymap.set("n", "<M-k>", '<Cmd>lua require("tmux").resize_top()<CR>', { silent = true })
keymap.set("n", "<M-l>", '<Cmd>lua require("tmux").resize_right()<CR>', { silent = true })

-- Split windows
keymap.set("n", "ss", ":vsplit<Return>", opts)
keymap.set("n", "sv", ":split<Return>", opts)

vim.keymap.set("n", "<leader>nt", ":Neotree reveal<CR>", { desc = "NeoTree reveal", silent = true, noremap = true })

-- Tmux
-- Open a new horizontal split in Tmux
vim.api.nvim_set_keymap("n", "<leader>th", ":silent !tmux split-window -h<CR>", { noremap = true, silent = true })

-- Open a new vertical split in Tmux
vim.api.nvim_set_keymap("n", "<leader>tv", ":silent !tmux split-window -v<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>")

--  Remmove other mapping for K to allow 20k movement below
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local buf = args.buf
    pcall(vim.api.nvim_buf_del_keymap, buf, "n", "K")
    vim.api.nvim_buf_set_keymap(buf, "n", "H", "<cmd>lua vim.lsp.buf.hover()<CR>", { noremap = true, silent = true })
  end,
})

-- Remap J and K to instead move between lines
vim.api.nvim_set_keymap("n", "J", "20j", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "K", "20k", { noremap = true, silent = true })

-- Python support
vim.g.lazyvim_python_lsp = "pyright"
--
-- Telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>cg", builtin.current_buffer_fuzzy_find, { desc = "Code grep on currently opened file" })
vim.keymap.set("n", "<leader>ct", builtin.current_buffer_tags, { desc = "Code tags on currently opened file" })
