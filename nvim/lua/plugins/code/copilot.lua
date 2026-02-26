return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        panel = { enabled = false },
        suggestion = {
          auto_trigger = true,
          hide_during_completion = true,
          keymap = {
            accept = "<Tab>",      -- Tab to accept inline suggestions
            accept_word = "<M-w>", -- Alt+W to accept word
            accept_line = "<M-j>", -- Alt+J to accept line
            next = "<M-]>",        -- Next suggestion
            prev = "<M-[>",        -- Previous suggestion
            dismiss = "<C-]>",     -- Dismiss suggestion
          },
        },
      })

      -- Hide Copilot suggestions when blink.cmp menu is open
      vim.api.nvim_create_autocmd("User", {
        pattern = "BlinkCmpMenuOpen",
        callback = function()
          vim.b.copilot_suggestion_hidden = true
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "BlinkCmpMenuClose",
        callback = function()
          vim.b.copilot_suggestion_hidden = false
        end,
      })
    end,
  },

}
