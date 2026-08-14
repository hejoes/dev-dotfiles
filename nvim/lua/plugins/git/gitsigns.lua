-- Adds git related signs to the gutter, as well as utilities for managing changes.
-- NOTE: gitsigns is already included by LazyVim with a base config. This adds the
-- recommended keymaps AND absorbs everything the old git-blame.nvim plugin did
-- (always-on inline blame + open/copy commit on GitHub) so we run ONE git-blame
-- source instead of two overlapping ones.

-- Relative "2 hours ago" style time, to match the old git-blame.nvim `%r` format.
local function relative_time(epoch)
  local diff = os.time() - tonumber(epoch)
  local units = {
    { 31536000, "year" },
    { 2592000, "month" },
    { 86400, "day" },
    { 3600, "hour" },
    { 60, "minute" },
  }
  for _, u in ipairs(units) do
    if diff >= u[1] then
      local n = math.floor(diff / u[1])
      return n .. " " .. u[2] .. (n > 1 and "s" or "") .. " ago"
    end
  end
  return "just now"
end

-- Resolve the commit SHA for the current line via `git blame`. Returns nil for
-- uncommitted lines (all-zero SHA) or files outside a repo.
local function current_line_sha()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    return nil
  end
  local line = vim.fn.line(".")
  local out = vim.fn.systemlist({
    "git",
    "-C",
    vim.fn.fnamemodify(file, ":h"),
    "blame",
    "-L",
    line .. "," .. line,
    "--porcelain",
    "--",
    file,
  })
  if vim.v.shell_error ~= 0 or #out == 0 then
    return nil
  end
  local sha = out[1]:match("^(%x+)")
  if not sha or sha:match("^0+$") then
    return nil
  end
  return sha
end

-- `gh browse` the current line's commit (open in browser, or -n to just get URL).
local function gh_commit(open)
  local sha = current_line_sha()
  if not sha then
    vim.notify("No committed change on this line", vim.log.levels.WARN)
    return
  end
  local args = { "gh", "browse", sha }
  if not open then
    table.insert(args, "-n") -- --no-browser: print URL instead of opening
  end
  local out = vim.fn.system(args)
  if vim.v.shell_error ~= 0 then
    vim.notify("gh failed: " .. out, vim.log.levels.ERROR)
    return
  end
  if not open then
    local url = vim.trim(out)
    vim.fn.setreg("+", url)
    vim.notify("Copied commit URL: " .. url)
  end
end

return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      -- Always-on inline blame (replaces git-blame.nvim). GitLens-style format.
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        ignore_whitespace = true,
        delay = 300,
      },
      current_line_blame_formatter = function(_, blame_info)
        return {
          {
            string.format(
              "  %s • %s • %s",
              blame_info.summary or "",
              relative_time(blame_info.author_time),
              blame_info.author
            ),
            "Comment",
          },
        }
      end,
      current_line_blame_formatter_nc = function()
        return { { "  Not Committed Yet", "Comment" } }
      end,
      on_attach = function(bufnr)
        local gitsigns = require("gitsigns")

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map("n", "]c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gitsigns.nav_hunk("next")
          end
        end, { desc = "Jump to next git [c]hange" })

        map("n", "[c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gitsigns.nav_hunk("prev")
          end
        end, { desc = "Jump to previous git [c]hange" })

        -- Actions - GitLens-like features
        map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview git hunk" })
        map("n", "<leader>hb", function()
          gitsigns.blame_line({ full = true })
        end, { desc = "Show git blame for line (full)" })
        map("n", "<leader>hd", gitsigns.diffthis, { desc = "Diff this file" })
        map("n", "<leader>hD", function()
          gitsigns.diffthis("~")
        end, { desc = "Diff against last commit" })

        -- Inline blame + GitHub commit helpers (absorbed from git-blame.nvim)
        map("n", "<leader>gb", gitsigns.toggle_current_line_blame, { desc = "Toggle inline git blame" })
        map("n", "<leader>go", function()
          gh_commit(true)
        end, { desc = "Open commit in GitHub" })
        map("n", "<leader>gy", function()
          gh_commit(false)
        end, { desc = "Copy commit URL" })
        map("n", "<leader>gc", function()
          local sha = current_line_sha()
          if not sha then
            vim.notify("No committed change on this line", vim.log.levels.WARN)
            return
          end
          vim.fn.setreg("+", sha)
          vim.notify("Copied commit SHA: " .. sha)
        end, { desc = "Copy commit SHA" })

        -- Toggles
        map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "[T]oggle git show [b]lame line" })
        map("n", "<leader>tD", gitsigns.toggle_deleted, { desc = "[T]oggle git show [D]eleted" })
      end,
    },
  },
}
