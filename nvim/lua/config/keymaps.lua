-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymap = vim.keymap
local opts = { noremap = true, silent = true }
local Util = require("lazyvim.util")

keymap.set("n", "ml", "<C-w>h", { desc = "Go to left window", silent = true })
keymap.set("n", "mr", "<C-w>l", { desc = "Go to right window", silent = true })
keymap.set("n", "mj", "<C-w>j", { desc = "Go to lower window", silent = true })
keymap.set("n", "mk", "<C-w>k", { desc = "Go to upper window", silent = true })

keymap.del({ "n", "i", "v" }, "<A-j>")
keymap.del({ "n", "i", "v" }, "<A-k>")
keymap.del("n", "<C-Left>")
keymap.del("n", "<C-Down>")
keymap.del("n", "<C-Up>")
keymap.del("n", "<C-Right>")

-- Split windows (sh = horizontal split, sv = vertical split)
keymap.set("n", "sh", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)

--  Tab management
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
keymap.set("n", "<leader>tf", "<cmd>tabnew<CR>", { desc = "Open current tab in new tab" })

-- Resolve the TOP of the project by walking up from the current file to the
-- OUTERMOST directory containing a `.git`. This is independent of where nvim
-- was launched and of the window-local `lcd` (autocmds.lua), so grep always
-- spans the whole repo even when the current file is deeply nested or nvim was
-- opened inside a subfolder like `backend/`. Falls back to the global cwd when
-- the file isn't inside a git repo.
local function project_root()
  local buf = vim.api.nvim_buf_get_name(0)
  local start = (buf ~= "" and vim.fn.filereadable(buf) == 1) and vim.fs.dirname(buf) or vim.fn.getcwd(-1, -1)
  local candidates = { start }
  for parent in vim.fs.parents(start) do
    candidates[#candidates + 1] = parent
  end
  local outermost
  for _, dir in ipairs(candidates) do
    if vim.uv.fs_stat(dir .. "/.git") then
      outermost = dir -- keep overwriting so the highest match wins
    end
  end
  return outermost or vim.fn.getcwd(-1, -1)
end

-- Telescope - Fixed to ensure project-wide search
keymap.set("n", "<leader>cG", function()
  local root = project_root()
  require("telescope.builtin").live_grep({
    cwd = root,
    prompt_title = "Live Grep: " .. vim.fn.fnamemodify(root, ":~"),
    additional_args = { "--hidden", "--glob", "!.git/" },
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
    additional_args = { "--hidden", "--glob", "!.git/" },
  })
end, { desc = "Code grep in current working directory" })

-- Neotree
keymap.set("n", "<leader>nt", ":Neotree reveal<CR>", { desc = "NeoTree reveal", silent = true, noremap = true })

-- d and c don't copy in normal mode (black hole register)
vim.keymap.set("n", "d", '"_d', { desc = "Delete without copying" })
vim.keymap.set("n", "c", '"_c', { desc = "Change without copying" })

-- Visual mode: d, c and C don't copy either (black hole register)
vim.keymap.set("v", "d", '"_d', { desc = "Delete without copying" })
vim.keymap.set("v", "c", '"_c', { desc = "Change without copying" })
vim.keymap.set("v", "C", '"_C', { desc = "Change to EOL without copying" })

-- <leader>d and <leader>c to delete/change AND copy to clipboard (normal + visual)
keymap.set("n", "<leader>d", [["+d]], { desc = "Delete and copy to clipboard" })
keymap.set("n", "<leader>c", [["+c]], { desc = "Change and copy to clipboard" })
keymap.set("v", "<leader>d", [["+d]], { desc = "Delete and copy to clipboard" })
keymap.set("v", "<leader>c", [["+c]], { desc = "Change and copy to clipboard" })

-- Cmd+C to copy visual selection to clipboard (macOS)
keymap.set("v", "<D-c>", '"+y', { desc = "Copy to clipboard" })

-- word motions (w/W/b/B) shouldn't bleed across the line boundary: with no
-- explicit count, forward motions stop at end-of-line and backward motions
-- stop at start-of-line instead of jumping onto the neighbouring line's
-- first/last word (the classic vw/dw/cw "eats the newline" annoyance, and
-- its mirror image going backward with b/B).
local function char_class(ch, big)
  if ch == "" or ch:match("%s") then
    return "blank"
  elseif big then
    return "nonblank"
  elseif ch:match("[%w_]") then
    return "word"
  else
    return "punct"
  end
end

-- w/W: skip the rest of the current word/punct run (not counted as "next"),
-- then any blanks; if anything's left on the line, a real next word starts
-- here, so let the real motion run. Otherwise land on `$` instead of crossing.
local function eol_safe_fwd(real_key, big)
  return function()
    if vim.v.count > 0 then
      return real_key
    end
    local rest = vim.api.nvim_get_current_line():sub(vim.fn.col("."))
    local cur_class = char_class(rest:sub(1, 1), big)
    local i = 1
    if cur_class ~= "blank" then
      while i <= #rest and char_class(rest:sub(i, i), big) == cur_class do
        i = i + 1
      end
    end
    while i <= #rest and char_class(rest:sub(i, i), big) == "blank" do
      i = i + 1
    end
    return (i <= #rest) and real_key or "$"
  end
end

-- b/B: unlike forward, any non-blank earlier on the line is a valid target
-- (either the start of the current word, or an earlier one) - no need to
-- skip the current run. If nothing but blanks precede the cursor, there's no
-- word-start left on this line, so land on `0` instead of crossing back.
local function bol_safe_bwd(real_key)
  return function()
    if vim.v.count > 0 then
      return real_key
    end
    local before = vim.api.nvim_get_current_line():sub(1, vim.fn.col(".") - 1)
    return before:match("%S") and real_key or "0"
  end
end

keymap.set({ "n", "x", "o" }, "w", eol_safe_fwd("w", false), { expr = true, desc = "w (stay on line)" })
keymap.set({ "n", "x", "o" }, "W", eol_safe_fwd("W", true), { expr = true, desc = "W (stay on line)" })
keymap.set({ "n", "x", "o" }, "b", bol_safe_bwd("b"), { expr = true, desc = "b (stay on line)" })
keymap.set({ "n", "x", "o" }, "B", bol_safe_bwd("B"), { expr = true, desc = "B (stay on line)" })

-- Resize windows using Option + Arrow Keys
vim.api.nvim_set_keymap("n", "<M-Up>", ":resize +6<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<M-Down>", ":resize -6<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<M-Left>", ":vertical resize -6<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<M-Right>", ":vertical resize +6<CR>", { noremap = true, silent = true })

-- AdvancedGitSearch (diffview keymaps are in diffview.lua for proper lazy-loading)
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
  Snacks.lazygit({ cwd = Util.root(), win = { border = "none" } })
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
