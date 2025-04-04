return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "css", "scss" })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        cssls = {},
        tailwindcss = {},
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        css = { "prettier" },
        scss = { "prettier" },
      },
    },
  },
}
