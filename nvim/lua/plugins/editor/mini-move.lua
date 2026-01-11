-- Allows to move selected code left,right and so on (indented way)
return {
  "nvim-mini/mini.move",
  event = "VeryLazy",
  opts = {
    mappings = {
      left = "H",
      right = "L",
      -- down = "J",
      -- up = "K",

      line_left = "",
      line_right = "",
      line_down = "",
      line_up = "",
    },
  },
}
