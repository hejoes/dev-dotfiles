-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
local M = {}

M.update_cwd_on_open = function() -- Updates cwd when switchig from terminal path to another neovim path for example with yazi, otherwise by default it kept the terminal path.
    local current_dir = vim.fn.expand("%:p:h")

    if vim.fn.isdirectory(current_dir) == 1 then
        vim.cmd("lcd " .. current_dir)
    else
        print("Could not update working directory.")
    end
end

vim.api.nvim_create_autocmd("BufEnter", {
    callback = M.update_cwd_on_open,
})

return M
