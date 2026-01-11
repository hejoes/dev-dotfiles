return {
  "sindrets/diffview.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  cmd = {
    "DiffviewOpen",
    "DiffviewClose",
    "DiffviewToggleFiles",
    "DiffviewFocusFiles",
    "DiffviewFileHistory",
  },
  keys = {
    { "<leader>gdo", "<cmd>DiffviewOpen<cr>", desc = "Diff compare HEAD & MergeConflicts" },
    { "<leader>gdf", "<cmd>DiffviewFileHistory --follow %<cr>", desc = "File commit history" },
    { "<leader>gdr", "<cmd>DiffviewFileHistory<cr>", desc = "Repo commit history" },
    { "<leader>gdc", "<cmd>DiffviewClose<cr>", desc = "Close Diffview" },
    {
      "<leader>gdf",
      "<Esc><Cmd>'<,'>DiffviewFileHistory --follow<CR>",
      desc = "File commit history (range)",
      mode = "v",
    },
  },
  opts = {
    -- Only non-default configurations
    enhanced_diff_hl = true, -- Better syntax highlighting in diffs (default: false)

    view = {
      merge_tool = {
        layout = "diff3_mixed", -- Use mixed layout for merge conflicts (default: diff3_horizontal)
        disable_diagnostics = true, -- Cleaner merge conflict view
      },
    },

    -- Explicit keymaps to ensure they work
    keymaps = {
      view = {
        -- Main diff view keymaps
        { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
        { "n", "<leader>q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
      },
      file_panel = {
        -- File panel keymaps
        { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
        { "n", "<leader>q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
      },
      file_history_panel = {
        { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
        { "n", "<leader>q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
      },
    },
  },
}
