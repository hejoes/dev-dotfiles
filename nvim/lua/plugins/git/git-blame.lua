return {
  "f-person/git-blame.nvim",
  -- load the plugin at startup
  event = "VeryLazy",
  keys = {
    -- { "<leader>gbt", "<cmd>GitBlameToggle<cr>", desc = "Toggle Git Blame" },
    { "<leader>gbe", "<cmd>GitBlameEnable<cr>", desc = "Enable Git Blame" },
    { "<leader>gbd", "<cmd>GitBlameDisable<cr>", desc = "Disable Git Blame" },
    { "<leader>gbo", "<cmd>GitBlameOpenFileURL <cr>", desc = "Open Commit in Gitlab/Github" },
  },
  -- Because of the keys part, you will be lazy loading this plugin.
  -- The plugin wil only load once one of the keys is used.
  -- If you want to load the plugin at startup, add something like event = "VeryLazy",
  -- or lazy = false. One of both options will work.
  opts = {
    -- message_template = "<author> • <relative-time> • <summary>", -- template showing author, relative time, and summary
    date_format = "%r", -- relative time format
    virtual_text_column = 1, -- virtual text start column, check Start virtual text at column section for more options
  },
}
