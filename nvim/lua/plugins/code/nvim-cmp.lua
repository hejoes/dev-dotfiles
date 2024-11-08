return {
  "hrsh7th/nvim-cmp",
  opts = function(_, opts)
    local cmp = require("cmp")

    -- Keep the existing configuration
    opts = vim.tbl_deep_extend("force", opts, {
      -- Add your custom configuration here
    })

    -- Setup cmdline completion for "/" search
    cmp.setup.cmdline("/", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "buffer" },
      },
    })

    -- Setup cmdline completion for ":" commands
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        { name = "cmdline" },
      }),
      matching = { disallow_symbol_nonprefix_matching = false },
    })

    return opts
  end,
  -- Make sure to include the required dependencies
  dependencies = {
    "hrsh7th/cmp-cmdline",
  },
}
