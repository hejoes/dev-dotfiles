-- Single-picker policy: snacks.picker is the default (set via
-- vim.g.lazyvim_picker = "snacks" in lua/config/options.lua).
--
-- fzf-lua was a third redundant picker (snacks + telescope + fzf-lua). We drop
-- it here. telescope is intentionally kept because the custom Helm values picker
-- (<leader>hv) and telescope-terraform{,-doc}.nvim depend on its API.
return {
  { "ibhagwan/fzf-lua", enabled = false },
  {
    "folke/snacks.nvim",
    keys = {
      -- Find Files: include dotdirs like .github (still respects .gitignore/
      -- .git/info/exclude, so .git, .terraform, .cs, .omc stay hidden).
      { "<leader>ff", LazyVim.pick("files", { hidden = true }), desc = "Find Files (Root Dir)" },
      -- Space-space: quick buffer switcher.
      { "<leader><leader>", function() Snacks.picker.buffers() end, desc = "Buffers" },
    },
  },
}
