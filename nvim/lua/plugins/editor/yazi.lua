return {
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>yy",
        function()
          -- Open Yazi in the main window and update Neovim's cwd
          vim.cmd("Yazi")
        end,
        desc = "Open Yazi in main window",
      },
    },
    opts = {
      open_for_directories = true,
      keymaps = {
        open_file_in_horizontal_split = "<c-h>",
        open_file_in_vertical_split = "<c-v>",
        open_file_in_new_tab = "<c-t>",
      },
      -- Automatically set Neovim's `cwd` when navigating in Yazi
      on_dir_change = function(new_dir)
        vim.cmd("lcd " .. new_dir)
      end,
      -- Open Yazi without popup
      open_mode = "replace", -- 'replace' mode to open in the main window
    },
  },
}
