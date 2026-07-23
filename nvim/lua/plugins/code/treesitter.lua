return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "css", -- Styles, plus <style> blocks injected from HTML
        "dockerfile",
        "gitignore",
        "hcl", -- For Terraform and HCL files
        "html", -- Hosts JS/CSS/JSX injections in <script>/<style>
        "javascript", -- <script> blocks and .js files
        "jsdoc",
        "json",
        "json5",
        "jsonc",
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline",
        "python",
        "regex",
        "scss",
        "sql",
        "terraform", -- Explicit terraform parser
        "tsx", -- JSX/TSX, and text/babel <script> injections (see after/queries/html)
        "typescript",
        "vim",
        "vimdoc",
        "xml", -- SVG and standalone XML
        "yaml",
      },
      auto_install = true,
      highlight = {
        enable = true, -- Enable syntax highlighting
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "VeryLazy",
  },
}
