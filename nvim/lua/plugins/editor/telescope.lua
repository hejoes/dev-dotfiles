return {
  {
    "nvim-telescope/telescope.nvim",

    --  Add Helm values picker. With <leader>mv picker pops up where you have to choose repository, chart and release to see specific Helm values chart. It then opens up in vertical view.
    config = function()
      local telescope = require("telescope")
      local pickers = require("telescope.pickers")
      local finders = require("telescope.finders")
      local conf = require("telescope.config").values
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")

      -- Function to read chart names and versions from repository
      local function get_charts_from_repo(repo_name)
        -- Get chart info using helm search with --versions flag to show all versions
        local search_output = vim.fn.system("helm search repo " .. repo_name .. " --versions")
        -- Parse the table-formatted output
        local search_results = {}
        for line in search_output:gmatch("[^\r\n]+") do
          -- Skip the header line
          if not line:match("^NAME") then
            local name, chart_version, app_version, description = line:match("([^%s]+)%s+([^%s]+)%s+([^%s]+)%s+(.*)")
            if name then
              table.insert(search_results, {
                name = name,
                version = chart_version,
                app_version = app_version,
                description = description:gsub("^%s*(.-)%s*$", "%1"), -- trim spaces
              })
            end
          end
        end

        -- Create a map to group versions by chart name
        local chart_versions = {}
        for _, entry in ipairs(search_results) do
          -- Strip both the repository name and any potential parent repository name from the chart name
          local chart_name = entry.name:match("[^/]+$") -- This will get only the last part after the last '/'
          if not chart_versions[chart_name] then
            chart_versions[chart_name] = {}
          end
          -- Store more details about each version
          table.insert(chart_versions[chart_name], {
            version = entry.version,
            app_version = entry.app_version,
            description = entry.description,
          })
        end

        -- Convert to array format
        local charts = {}
        for chart_name, versions in pairs(chart_versions) do
          table.insert(charts, {
            name = chart_name,
            versions = versions,
          })
        end

        return charts
      end

      -- Custom Helm Values Picker
      local function fetch_helm_values()
        -- Get repositories using helm repo list
        local repos_output = vim.fn.system("helm repo list")
        -- Parse the table-formatted output
        local repos = {}
        for line in repos_output:gmatch("[^\r\n]+") do
          -- Skip the header line
          if not line:match("^NAME") then
            local name, url = line:match("([^%s]+)%s+(.*)")
            if name and url then
              table.insert(repos, {
                name = name,
                url = url:gsub("^%s*(.-)%s*$", "%1"), -- trim spaces
              })
            end
          end
        end

        -- Create results table for repositories
        local repo_results = {}
        for _, repo in ipairs(repos) do
          local charts = get_charts_from_repo(repo.name)
          -- Only add repositories that have charts
          if #charts > 0 then
            table.insert(repo_results, {
              value = repo.name,
              display = repo.name .. " (" .. repo.url .. ")",
              ordinal = repo.name,
              charts = charts,
            })
          end
        end

        -- Show repository picker
        pickers
          .new({}, {
            prompt_title = "Select Helm Repository",
            finder = finders.new_table({
              results = repo_results,
              entry_maker = function(entry)
                return {
                  value = entry,
                  display = entry.display,
                  ordinal = entry.ordinal,
                }
              end,
            }),
            sorter = conf.generic_sorter({}),
            attach_mappings = function(_, map)
              map("i", "<CR>", function(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)

                if selection then
                  local repo = selection.value
                  -- Show charts picker for selected repository
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
                            -- Show version picker for selected chart
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
                                      -- Construct and show the helm command
                                      local helm_cmd = string.format(
                                        "helm show values %s/%s --version %s",
                                        repo.value,
                                        chart.name,
                                        version_selection.value
                                      )

                                      -- Show the command for debugging
                                      vim.notify("Executing: " .. helm_cmd, vim.log.levels.INFO)

                                      -- Execute the helm command
                                      local output_lines = vim.fn.systemlist(helm_cmd)

                                      -- Process the output
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
                                        vim.notify(
                                          "No values found for the selected chart version",
                                          vim.log.levels.ERROR
                                        )
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

      -- Set up the keymap
      vim.keymap.set("n", "<leader>hv", fetch_helm_values, { desc = "Helm Values" })
    end,
  },
}
