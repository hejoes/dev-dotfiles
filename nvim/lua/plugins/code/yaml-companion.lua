return {
  {
    "someone-stole-my-name/yaml-companion.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      -- Load the YAML schema extension for Telescope
      require("telescope").load_extension("yaml_schema")

      schemas = {
        {
        name = "Kubernetes 1.22.4",
        uri = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.22.4-standalone-strict/all.json",
        },
        {
          name = "Helm values",
          uri = "https://json.schemastore.org/helm-values.json",
        },
        {
          name = "Argo CD Application",
          uri = "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json"
        },
      }
    end,
  },
}
