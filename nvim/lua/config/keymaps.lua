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

keymap.set("n", "ml", "<C-w>h", { desc = "Go to left window", silent = true })
keymap.set("n", "mr", "<C-w>l", { desc = "Go to right window", silent = true })
keymap.set("n", "mj", "<C-w>j", { desc = "Go to lower window", silent = true })
keymap.set("n", "mk", "<C-w>j", { desc = "Go to upper window", silent = true })

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

--  Tab management
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
keymap.set("n", "<leader>tf", "<cmd>tabnew<CR>", { desc = "Open current tab in new tab" })

-- Telescope - Fixed to ensure project-wide search
keymap.set("n", "<leader>cG", function()
  require("telescope.builtin").live_grep({
    cwd = require("lazyvim.util").root(),
    prompt_title = "Live Grep (Project Root)",
  })
end, { desc = "Code grep in entire project" })

keymap.set("n", "<leader>cg", function()
  require("telescope.builtin").current_buffer_fuzzy_find()
end, { desc = "Code grep on currently opened file" })

keymap.set("n", "<leader>ct", function()
  require("telescope.builtin").current_buffer_tags()
end, { desc = "Code tags on currently opened file" })

-- Alternative project-wide search with ripgrep
keymap.set("n", "<leader>cR", function()
  require("telescope.builtin").live_grep({
    cwd = vim.fn.getcwd(),
    prompt_title = "Live Grep (Current Working Directory)",
  })
end, { desc = "Code grep in current working directory" })

-- Neotree
keymap.set("n", "<leader>nt", ":Neotree reveal<CR>", { desc = "NeoTree reveal", silent = true, noremap = true })

-- Make ALL d and c commands never copy (use black hole register for everything)
vim.keymap.set("n", "d", '"_d', { desc = "Delete without copying" })
vim.keymap.set("n", "c", '"_c', { desc = "Change without copying" })
vim.keymap.set("v", "d", '"_d', { desc = "Delete without copying" })
vim.keymap.set("v", "c", '"_c', { desc = "Change without copying" })

-- Use <leader>d and <leader>c when you DO want to copy (cut)
keymap.set({ "n", "v" }, "<leader>d", [["+d]], { desc = "Delete and copy to clipboard" })
keymap.set({ "n", "v" }, "<leader>c", [["+c]], { desc = "Change and copy to clipboard" })

-- Resize windows using Option + Arrow Keys
vim.api.nvim_set_keymap("n", "<M-Up>", ":resize +6<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<M-Down>", ":resize -6<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<M-Left>", ":vertical resize -6<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<M-Right>", ":vertical resize +6<CR>", { noremap = true, silent = true })

-- Tmux
-- Open a new horizontal split in Tmux
vim.api.nvim_set_keymap("n", "<leader>th", ":silent !tmux split-window -h<CR>", { noremap = true, silent = true })

-- Open a new vertical split in Tmux
vim.api.nvim_set_keymap("n", "<leader>tv", ":silent !tmux split-window -v<CR>", { noremap = true, silent = true })

keymap.set("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>")

-- Keymaps for git
keymap.set("n", "<leader>gdf", "<cmd>DiffviewFileHistory --follow %<cr>", { desc = "File commit history" })
keymap.set("n", "<leader>gdr", "<cmd>DiffviewFileHistory --follow %<cr>", { desc = "Repo commit history" })
keymap.set(
  "v",
  "<leader>gdv",
  "<Esc><Cmd>'<,'>DiffviewFileHistory --follow<CR>",
  { desc = "File history from selection" }
)
keymap.set("n", "<leader>gdo", "<cmd>DiffviewOpen<cr>", { desc = "Diff compare HEAD & MergeConflicts" })
keymap.set("n", "<leader>gda", "<cmd>AdvancedGitSearch <cr>", { desc = "AdvancedGitSearch" })

--  Remmove other mapping for K to allow 20k movement below
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local buf = args.buf
    pcall(vim.api.nvim_buf_del_keymap, buf, "n", "K")
    vim.api.nvim_buf_set_keymap(buf, "n", "H", "<cmd>lua vim.lsp.buf.hover()<CR>", { noremap = true, silent = true })
  end,
})

-- Borderless lazygit
keymap.set("n", "<leader>gg", function()
  Util.terminal({ "lazygit" }, { cwd = Util.root(), esc_esc = false, ctrl_hjkl = false, border = "none" })
end, { desc = "Lazygit (root dir)" })

-- Remap J and K to instead move between lines
vim.api.nvim_set_keymap("n", "J", "20j", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "K", "20k", { noremap = true, silent = true })

-- Python support
vim.g.lazyvim_python_lsp = "pyright"

-- Remove default LazyVim keymaps
local function del_keymap()
  local keys = {
    "<leader>cf",
    "<leader>cF",
    "<leader>cc",
    "<leader>cl",
    "<leader>cm",
    "<leader>ft",
    "<leader>fT",
    "<leader>K",
    "<leader>,",
    "<leader>S",
    "<leader>fb",
    "<leader>b",
    "<leader>/",
    "<leader>gY",
    "<leader>ge",
    "<leader>gf",
  }
  for _, key in ipairs(keys) do
    pcall(vim.keymap.del, "n", key)
  end
end

vim.api.nvim_create_autocmd("User", {
  pattern = "LazyVimKeymaps",
  callback = function()
    vim.schedule(del_keymap)
  end,
})
