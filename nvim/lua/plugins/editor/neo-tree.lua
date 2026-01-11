-- NeoTree file explorer configuration
return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          visible = true, -- Show hidden files by default
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_hidden = false, -- For Windows
        },
      },
    },
  },
}
