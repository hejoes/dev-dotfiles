return {
  {
    'nathom/filetype.nvim',
    opts = {
      overrides = {
        extensions = {
          sql = 'sql',
          sh = 'sh',
          tf = 'terraform',
          tfvars = 'terraform',
          tfstate = 'json',
        },
      },
    },
  },
}
