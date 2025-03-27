return {
  -- Filetype detection for Terraform files
  {
    "nathom/filetype.nvim",
    opts = {
      overrides = {
        extensions = {
          tf = "terraform",
          tfvars = "terraform",
          tfstate = "json",
          hcl = "hcl",
        },
        literal = {
          [".terraformrc"] = "hcl",
          ["terraform.rc"] = "hcl",
        },
      },
    },
  },

  -- Terraform-specific autocmds for better file detection
  {
    "LazyVim/LazyVim",
    opts = function()
      -- Ensure proper filetype detection for Terraform files
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = { "*.tf", "*.tfvars" },
        callback = function()
          vim.bo.filetype = "terraform"
        end,
      })

      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = { "*.hcl", ".terraformrc", "terraform.rc" },
        callback = function()
          vim.bo.filetype = "hcl"
        end,
      })

      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = { "*.tfstate", "*.tfstate.backup" },
        callback = function()
          vim.bo.filetype = "json"
        end,
      })
    end,
  },

  -- Enhanced LSP configuration for Terraform
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        terraformls = {
          settings = {
            terraform = {
              validation = {
                enable = true,
              },
            },
          },
        },
      },
    },
  },

  -- Enhanced linting with tflint
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        terraform = { "tflint" },
        tf = { "tflint" },
      },
    },
  },

  -- Formatting support
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        terraform = { "terraform_fmt" },
        tf = { "terraform_fmt" },
        hcl = { "terraform_fmt" },
      },
    },
  },
}
