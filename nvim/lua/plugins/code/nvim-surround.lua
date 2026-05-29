return {
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    init = function()
      vim.g.nvim_surround_no_visual_mappings = true
    end,
    opts = {},
    keys = {
      { "gs", "<Plug>(nvim-surround-visual)", mode = "x", desc = "Surround selection" },
      { "gS", "<Plug>(nvim-surround-visual-line)", mode = "x", desc = "Surround selection (lines)" },
    },
  },
}
