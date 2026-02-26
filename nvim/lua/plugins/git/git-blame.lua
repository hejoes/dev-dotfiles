-- GitLens-style blame info in virtual text
return {
  "f-person/git-blame.nvim",
  event = "VeryLazy",
  opts = {
    enabled = true, -- Enable on startup
    message_template = " <summary> • <date> • <author>", -- GitLens-style format
    date_format = "%r", -- Relative date (e.g., "2 hours ago")
    virtual_text_column = 1, -- Show at column 1 (end of line)
    highlight_group = "Comment", -- Use comment color
    -- Don't show blame for these
    ignore_whitespace = true,
    message_when_not_committed = " Not Committed Yet",
  },
  keys = {
    { "<leader>gb", "<cmd>GitBlameToggle<cr>", desc = "Toggle Git Blame" },
    { "<leader>go", "<cmd>GitBlameOpenCommitURL<cr>", desc = "Open commit in GitHub" },
    { "<leader>gy", "<cmd>GitBlameCopyCommitURL<cr>", desc = "Copy commit URL" },
    { "<leader>gc", "<cmd>GitBlameCopySHA<cr>", desc = "Copy commit SHA" },
  },
}
