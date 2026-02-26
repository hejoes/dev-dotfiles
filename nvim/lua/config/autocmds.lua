-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Update local working directory to match the current file's directory
vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("UpdateCwdOnOpen", { clear = true }),
  callback = function()
    local buftype = vim.bo.buftype
    local filetype = vim.bo.filetype

    -- Don't run on special buffers (terminal, telescope, neo-tree, etc.)
    if buftype ~= "" or filetype == "neo-tree" or filetype == "TelescopePrompt" then
      return
    end

    local current_file = vim.fn.expand("%:p")
    if current_file == "" then
      return
    end

    local current_dir = vim.fn.expand("%:p:h")
    if vim.fn.isdirectory(current_dir) == 1 then
      vim.cmd("lcd " .. vim.fn.fnameescape(current_dir))
    end
  end,
})

-- Handle paste events in terminal to prevent freezes
vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("TerminalPasteFix", { clear = true }),
  callback = function()
    vim.opt_local.timeoutlen = 100
  end,
})
