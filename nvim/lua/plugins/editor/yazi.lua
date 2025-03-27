return {
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>yy",
        "<cmd>Yazi<cr>",
        desc = "Open yazi at the current file",
      },
    },
    opts = {
      -- Minimal configuration to avoid deprecated options
      open_for_directories = false,
      keymaps = {
        show_help = "<f1>",
      },
    },
  },
}
