-- Prefer opening the PR itself (full review/discussion) when the commit
-- subject references one - e.g. squash merges ending "(#153)" or a merge
-- commit "Merge pull request #154 from ...". Falls back to the bare commit
-- page when no PR number is found.
local function browse_commit(commit)
  if not commit then
    return
  end
  local pr = commit.subject and commit.subject:match("#(%d+)")
  vim.cmd("!gh browse " .. (pr or commit.hash))
end

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
    { "<leader>gdF", "<cmd>DiffviewOpen -- %<cr>", desc = "Diff current file (uncommitted changes)" },
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
        -- Open commit (or its PR, if referenced) in GitHub from diff view
        {
          "n",
          "<leader>go",
          function()
            local view = require("diffview.lib").get_current_view()
            if view and view.panel then
              local item = view.panel:get_item_at_cursor()
              browse_commit((item and item.commit) or (view.panel.cur_file and view.panel.cur_file.commit))
            end
          end,
          { desc = "Open commit/PR in GitHub" },
        },
      },
      file_panel = {
        -- File panel keymaps
        { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
        { "n", "<leader>q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
        -- Open commit (or its PR, if referenced) in GitHub from file panel
        {
          "n",
          "<leader>go",
          function()
            local view = require("diffview.lib").get_current_view()
            if view and view.panel then
              local item = view.panel:get_item_at_cursor()
              browse_commit((item and item.commit) or (view.panel.cur_file and view.panel.cur_file.commit))
            end
          end,
          { desc = "Open commit/PR in GitHub" },
        },
      },
      file_history_panel = {
        { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
        { "n", "<leader>q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
        -- Open commit (or its PR, if referenced) in remote GitHub
        {
          "n",
          "<leader>go",
          function()
            local view = require("diffview.lib").get_current_view()
            if view and view.panel then
              local entry = view.panel:get_log_entry_at_cursor()
              browse_commit(entry and entry.commit)
            end
          end,
          { desc = "Open commit/PR in GitHub" },
        },
        -- Alternative to <C-A-d> for Mac (doesn't work on Mac terminals)
        {
          "n",
          "gd",
          function()
            local view = require("diffview.lib").get_current_view()
            if view and view.panel then
              local entry = view.panel:get_log_entry_at_cursor()
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
