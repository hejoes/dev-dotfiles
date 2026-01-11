-- Search and replace with grug-far
-- Configure keymaps to work in both normal and insert mode
return {
  {
    "MagicDuck/grug-far.nvim",
    opts = {
      -- Make keymaps work in both normal mode AND insert mode
      -- This allows ,r to trigger replace even while typing in the search field
      keymaps = {
        replace = { n = "<localleader>r", i = "<localleader>r" },
        qflist = { n = "<localleader>q", i = "<localleader>q" },
        syncLocations = { n = "<localleader>s", i = "<localleader>s" },
        syncLine = { n = "<localleader>l", i = "<localleader>l" },
        close = { n = "<localleader>c", i = "<localleader>c" },
        historyOpen = { n = "<localleader>t", i = "<localleader>t" },
        historyAdd = { n = "<localleader>a", i = "<localleader>a" },
        refresh = { n = "<localleader>f", i = "<localleader>f" },
        openLocation = { n = "<localleader>o", i = "<localleader>o" },
        abort = { n = "<localleader>b", i = "<localleader>b" },
        toggleShowCommand = { n = "<localleader>w", i = "<localleader>w" },
        swapEngine = { n = "<localleader>e", i = "<localleader>e" },
        previewLocation = { n = "<localleader>i", i = "<localleader>i" },
        swapReplacementInterpreter = { n = "<localleader>x", i = "<localleader>x" },
        applyNext = { n = "<localleader>j", i = "<localleader>j" },
        applyPrev = { n = "<localleader>k", i = "<localleader>k" },
        syncNext = { n = "<localleader>n", i = "<localleader>n" },
        syncPrev = { n = "<localleader>p", i = "<localleader>p" },
        syncFile = { n = "<localleader>v", i = "<localleader>v" },
      },
    },
  },
}
