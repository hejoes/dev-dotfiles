return {

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "markdown", "markdown_inline" })
    end,
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        markdown = { "deno_fmt" },
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- WARN: the TOC action only showed if documentation section change !!
        marksman = {},
      },
    },
  },
  --
  -- {
  --   "mfussenegger/nvim-lint",
  --   event = { "BufReadPre", "BufNewFile" },
  --   opts = {
  --     linters_by_ft = {
  --       markdown = { "markdownlint" },
  --     },
  --   },
  -- },

  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = function()
      require("lazy").load({ plugins = { "markdown-preview.nvim" } })
      vim.fn["mkdp#util#install"]()
    end,
    keys = {
      {
        "<leader>mp",
        ft = "markdown",
        "<cmd>MarkdownPreviewToggle<cr>",
        desc = "Markdown Preview",
      },
    },
    config = function()
      vim.cmd([[do FileType]])
    end,
  },
  -- TEMPORARILY DISABLED: Testing if this causes Avante duplication
  -- {
  --   "MeanderingProgrammer/render-markdown.nvim",
  --   opts = {
  --     file_types = { "markdown", "Avante" },
  --     code = {
  --       sign = false,
  --       width = "block",
  --       right_pad = 1,
  --     },
  --     heading = {
  --       sign = false,
  --       icons = {},
  --     },
  --     -- Add dash configuration to prevent the original error
  --     dash = {
  --       icon = "─",
  --       width = "full",
  --     },
  --     -- Ensure proper rendering for Avante
  --     render_modes = { "n", "c", "t" },
  --     anti_conceal = {
  --       enabled = true,
  --     },
  --   },
  --   ft = { "markdown", "norg", "rmd", "org", "Avante" },
  --   config = function(_, opts)
  --     require("render-markdown").setup(opts)
  --   end,
  -- },
}
