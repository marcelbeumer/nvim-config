vim.cmd([[au BufNewFile,BufRead *.tf set ft=terraform ]])
vim.cmd([[au BufNewFile,BufRead *.hcl,*.terraformrc,terraform.rc set ft=hcl ]])
vim.cmd([[au BufNewFile,BufRead *.tfstate,*.tfstate.backup set ft=json ]])

return {

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        terraformls = {},
      },
    },
  },
}
