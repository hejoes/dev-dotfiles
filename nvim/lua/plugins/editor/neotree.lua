-- return {
--   "nvim-neo-tree/neo-tree.nvim",
--   dependencies = {
--     "nvim-lua/plenary.nvim",
--     "nvim-tree/nvim-web-devicons",
--     "MunifTanjim/nui.nvim",
--   },
--   cmd = "Neotree",
--   opts = {
--     window = {
--       position = "left",
--       width = 30,
--       mappings = {
--         ["Y"] = "none",
--         -- ["<C-v>"] = "open_vsplit",
--       },
--     },
--     filesystem = {
--       filtered_items = {
--         hide_dotfiles = false,
--         hide_by_name = {
--           ".git",
--           ".DS_Store",
--         },
--         always_show = {
--           ".env",
--         },
--       },
--     },
--     -- event_handlers = {
--     --   {
--     --     event = "file_opened",
--     --     handler = function(args)
--     --       -- Automatically set CWD to the directory of the opened file
--     --       local filepath = args.file_path
--     --       if filepath then
--     --         local directory = vim.fn.fnamemodify(filepath, ":h") -- Get the directory of the file
--     --         vim.fn.chdir(directory) -- Change the CWD to this directory
--     --       end
--     --       -- Automatically close Neo-tree when a file is opened
--     --       -- require("neo-tree.command").execute({ action = "close" })
--     --     end,
--     --   },
--     -- },
--   },
-- }
--

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim", -- Optional image support in preview window
      {
        "s1n7ax/nvim-window-picker",
        version = "2.*",
        config = function()
          require("window-picker").setup({
            use_winbar = "single-letter",

            filter_rules = {
              include_current_win = false,
              autoselect_one = true,
            },
          })
        end,
      },
    },
    config = function()
      -- Define diagnostic icons
      vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
      vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
      vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
      vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "DiagnosticSignHint" })

      require("neo-tree").setup({
        close_if_last_window = false,
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = true,
        open_files_do_not_replace_types = { "terminal", "trouble", "qf" },
        sort_case_insensitive = false,
        sort_function = nil,
        default_component_configs = {
          container = { enable_character_fade = true },
          indent = {
            indent_size = 2,
            padding = 1,
            with_markers = true,
            indent_marker = "│",
            last_indent_marker = "└",
            highlight = "NeoTreeIndentMarker",
            expander_collapsed = "",
            expander_expanded = "",
            expander_highlight = "NeoTreeExpander",
          },
          icon = {
            folder_closed = "",
            folder_open = "",
            folder_empty = "󰜌",
            provider = function(icon, node, state)
              if node.type == "file" or node.type == "terminal" then
                local success, web_devicons = pcall(require, "nvim-web-devicons")
                local name = node.type == "terminal" and "terminal" or node.name
                if success then
                  local devicon, hl = web_devicons.get_icon(name)
                  icon.text = devicon or icon.text
                  icon.highlight = hl or icon.highlight
                end
              end
            end,
            default = "*",
            highlight = "NeoTreeFileIcon",
          },
          modified = { symbol = "[+]", highlight = "NeoTreeModified" },
          name = { trailing_slash = false, use_git_status_colors = true, highlight = "NeoTreeFileName" },
          git_status = {
            symbols = {
              added = "",
              modified = "",
              deleted = "✖",
              renamed = "󰁕",
              untracked = "",
              ignored = "",
              unstaged = "󰄱",
              staged = "",
              conflict = "",
            },
          },
          file_size = { enabled = true, required_width = 64 },
          type = { enabled = true, required_width = 122 },
          last_modified = { enabled = true, required_width = 88 },
          created = { enabled = true, required_width = 110 },
        },
        window = {
          position = "left",
          width = 40,
          mapping_options = { noremap = true, nowait = true },
          mappings = {
            ["<space>"] = { "toggle_node", nowait = false },
            ["<2-LeftMouse>"] = "open",
            ["<cr>"] = "open",
            ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
            ["l"] = "focus_preview",
            ["S"] = "open_split",
            ["s"] = "open_vsplit",
            ["t"] = "open_tabnew",
            ["w"] = "open_with_window_picker",
            ["C"] = "close_node",
            ["z"] = "close_all_nodes",
            ["a"] = { "add", config = { show_path = "none" } },
            ["A"] = "add_directory",
            ["d"] = "delete",
            ["r"] = "rename",
            ["y"] = "copy_to_clipboard",
            ["x"] = "cut_to_clipboard",
            ["p"] = "paste_from_clipboard",
            ["c"] = "copy",
            ["m"] = "move",
            ["q"] = "close_window",
            ["R"] = "refresh",
            ["?"] = "show_help",
            ["<"] = "prev_source",
            [">"] = "next_source",
            ["i"] = "show_file_details",
          },
        },
        filesystem = {
          filtered_items = {
            visible = false,
            hide_dotfiles = false,
            hide_gitignored = false,
            hide_hidden = false,
          },
          follow_current_file = {
            enabled = false,
            leave_dirs_open = false,
          },
          group_empty_dirs = false,
          hijack_netrw_behavior = "open_default",
          use_libuv_file_watcher = false,
        },
        buffers = {
          follow_current_file = { enabled = true, leave_dirs_open = false },
          group_empty_dirs = true,
          show_unloaded = true,
          window = {
            mappings = {
              ["bd"] = "buffer_delete",
              ["<bs>"] = "navigate_up",
              ["."] = "set_root",
            },
          },
        },
        git_status = {
          window = {
            position = "float",
            mappings = {
              ["A"] = "git_add_all",
              ["gu"] = "git_unstage_file",
              ["ga"] = "git_add_file",
              ["gr"] = "git_revert_file",
              ["gc"] = "git_commit",
              ["gp"] = "git_push",
              ["gg"] = "git_commit_and_push",
            },
          },
        },
      })

      vim.cmd([[nnoremap \ :Neotree reveal<cr>]])
    end,
  },
}
