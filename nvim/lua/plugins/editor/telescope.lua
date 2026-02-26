-- Helm values picker: <leader>hv to browse repository -> chart -> version -> values

-- Function to read chart names and versions from repository
local function get_charts_from_repo(repo_name)
  local search_output = vim.fn.system("helm search repo " .. repo_name .. " --versions")
  local search_results = {}
  for line in search_output:gmatch("[^\r\n]+") do
    if not line:match("^NAME") then
      local name, chart_version, app_version, description = line:match("([^%s]+)%s+([^%s]+)%s+([^%s]+)%s+(.*)")
      if name then
        table.insert(search_results, {
          name = name,
          version = chart_version,
          app_version = app_version,
          description = description:gsub("^%s*(.-)%s*$", "%1"),
        })
      end
    end
  end

  local chart_versions = {}
  for _, entry in ipairs(search_results) do
    local chart_name = entry.name:match("[^/]+$")
    if not chart_versions[chart_name] then
      chart_versions[chart_name] = {}
    end
    table.insert(chart_versions[chart_name], {
      version = entry.version,
      app_version = entry.app_version,
      description = entry.description,
    })
  end

  local charts = {}
  for chart_name, versions in pairs(chart_versions) do
    table.insert(charts, { name = chart_name, versions = versions })
  end
  return charts
end

-- Custom Helm Values Picker
local function fetch_helm_values()
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  local repos_output = vim.fn.system("helm repo list")
  local repos = {}
  for line in repos_output:gmatch("[^\r\n]+") do
    if not line:match("^NAME") then
      local name, url = line:match("([^%s]+)%s+(.*)")
      if name and url then
        table.insert(repos, { name = name, url = url:gsub("^%s*(.-)%s*$", "%1") })
      end
    end
  end

  local repo_results = {}
  for _, repo in ipairs(repos) do
    local charts = get_charts_from_repo(repo.name)
    if #charts > 0 then
      table.insert(repo_results, {
        value = repo.name,
        display = repo.name .. " (" .. repo.url .. ")",
        ordinal = repo.name,
        charts = charts,
      })
    end
  end

  pickers
    .new({}, {
      prompt_title = "Select Helm Repository",
      finder = finders.new_table({
        results = repo_results,
        entry_maker = function(entry)
          return { value = entry, display = entry.display, ordinal = entry.ordinal }
        end,
      }),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(_, map)
        map("i", "<CR>", function(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)

          if selection then
            local repo = selection.value
            pickers
              .new({}, {
                prompt_title = "Select Chart from " .. repo.display,
                finder = finders.new_table({
                  results = repo.charts,
                  entry_maker = function(chart)
                    return {
                      value = chart,
                      display = chart.name .. " (" .. #chart.versions .. " versions)",
                      ordinal = chart.name,
                    }
                  end,
                }),
                sorter = conf.generic_sorter({}),
                attach_mappings = function(_, inner_map)
                  inner_map("i", "<CR>", function(inner_prompt_bufnr)
                    local chart_selection = action_state.get_selected_entry()
                    actions.close(inner_prompt_bufnr)

                    if chart_selection then
                      local chart = chart_selection.value
                      pickers
                        .new({}, {
                          prompt_title = "Select Version for " .. chart.name,
                          finder = finders.new_table({
                            results = chart.versions,
                            entry_maker = function(version_info)
                              return {
                                value = version_info.version,
                                display = string.format(
                                  "Version: %s (App: %s) - %s",
                                  version_info.version,
                                  version_info.app_version or "N/A",
                                  version_info.description or ""
                                ),
                                ordinal = version_info.version,
                              }
                            end,
                          }),
                          sorter = conf.generic_sorter({}),
                          attach_mappings = function(_, version_map)
                            version_map("i", "<CR>", function(version_prompt_bufnr)
                              local version_selection = action_state.get_selected_entry()
                              actions.close(version_prompt_bufnr)

                              if version_selection then
                                local helm_cmd = string.format(
                                  "helm show values %s/%s --version %s",
                                  repo.value,
                                  chart.name,
                                  version_selection.value
                                )
                                vim.notify("Executing: " .. helm_cmd, vim.log.levels.INFO)
                                local output_lines = vim.fn.systemlist(helm_cmd)

                                if #output_lines > 0 then
                                  local filename = string.format(
                                    "/tmp/helm_values_%s_%s_%s.yaml",
                                    repo.value:gsub("/", "_"),
                                    chart.name:gsub("/", "_"),
                                    version_selection.value:gsub("/", "_")
                                  )
                                  vim.fn.writefile(output_lines, filename)
                                  vim.cmd("vsplit " .. filename)
                                  vim.cmd("set filetype=yaml")
                                else
                                  vim.notify("No values found for the selected chart version", vim.log.levels.ERROR)
                                end
                              end
                            end)
                            return true
                          end,
                        })
                        :find()
                    end
                  end)
                  return true
                end,
              })
              :find()
          end
        end)
        return true
      end,
    })
    :find()
end

return {
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader>hv", fetch_helm_values, desc = "Helm Values" },
    },
  },
}
