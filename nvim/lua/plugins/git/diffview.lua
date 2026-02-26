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
        -- Open commit in GitHub from diff view
        {
          "n",
          "<leader>go",
          function()
            local view = require("diffview.lib").get_current_view()
            if view and view.panel then
              local cur_item = view.panel:cur_item()
              if cur_item and cur_item.commit then
                vim.cmd("!gh browse " .. cur_item.commit.hash)
              elseif view.panel.cur_file and view.panel.cur_file.commit then
                vim.cmd("!gh browse " .. view.panel.cur_file.commit.hash)
              end
            end
          end,
          { desc = "Open commit in GitHub" },
        },
      },
      file_panel = {
        -- File panel keymaps
        { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
        { "n", "<leader>q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
        -- Open commit in GitHub from file panel
        {
          "n",
          "<leader>go",
          function()
            local view = require("diffview.lib").get_current_view()
            if view and view.panel then
              if view.panel.cur_file and view.panel.cur_file.commit then
                vim.cmd("!gh browse " .. view.panel.cur_file.commit.hash)
              end
            end
          end,
          { desc = "Open commit in GitHub" },
        },
      },
      file_history_panel = {
        { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
        { "n", "<leader>q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
        -- Open commit in remote GitHub
        {
          "n",
          "<leader>go",
          function()
            local view = require("diffview.lib").get_current_view()
            if view and view.panel then
              local entry = view.panel:cur_item()
              if entry and entry.commit then
                vim.cmd("!gh browse " .. entry.commit.hash)
              end
            end
          end,
          { desc = "Open commit in GitHub" },
        },
        -- Alternative to <C-A-d> for Mac (doesn't work on Mac terminals)
        {
          "n",
          "gd",
          function()
            local view = require("diffview.lib").get_current_view()
            if view and view.panel then
              local entry = view.panel:cur_item()
              if entry and entry.commit then
                vim.cmd("DiffviewOpen " .. entry.commit.hash .. "^!")
              end
            end
          end,
          { desc = "Open full commit diff (all files)" },
        },
      },
    },
  },
}
