

-- init.lua


-- general

vim.g.mapleader = " "

vim.o.syntax = 'on'
vim.o.number = true
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.smartindent = true
vim.o.autoindent = true
--vim.o.termguicolors = true
vim.o.splitright = true

-- keymaps

vim.api.nvim_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", { noremap = true })


-- packer

require('packer').startup(function(use)

  use 'wbthomason/packer.nvim'

  use 'nordtheme/vim'

  use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.0',
	  requires = { {'nvim-lua/plenary.nvim'} }
  }

  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }

  use 'neovim/nvim-lspconfig'

  use {'ms-jpq/coq_nvim', branch = 'coq'}
  use {'ms-jpq/coq.artifacts', branch = 'artifacts'}
  use {'ms-jpq/coq.thirdparty', branch = '3p'}

  use({"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"})

  use {'nvim-lualine/lualine.nvim', requires = {'kyazdani42/nvim-web-devicons', opt = true}}

  use 'klen/nvim-config-local'

  use 'mfussenegger/nvim-dap'

  use {'stevearc/dressing.nvim'}
  use 'rcarriga/nvim-notify'

end)


-- telescope

local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

require('telescope').setup {}
require('telescope').load_extension('fzf')


-- lsp

local lspconfig = require('lspconfig')

-- Automatically start coq
vim.g.coq_settings = { auto_start = 'shut-up' }

-- Enable some language servers with the additional completion capabilities offered by coq_nvim
local servers = { 'clangd', 'tsserver', 'sqlls', 'marksman' }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup(require('coq').lsp_ensure_capabilities({
    -- on_attach = my_custom_on_attach,
  }))
end


-- nvim-config-local

require('config-local').setup {
  -- Default configuration (optional)
  config_files = { ".vimrc.lua", ".vimrc" },
  hashfile = vim.fn.stdpath("data") .. "/config-local",
  autocommands_create = true,
  commands_create = true,
  silent = false,
  lookup_parents = true,
}


-- treesitter

require'nvim-treesitter.configs'.setup {
  ensure_installed = {},
  sync_install = false,
  auto_install = true,

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}

-- dap

local dap = require('dap')
dap.adapters.lldb = {
  type = 'executable',
  command = '/opt/homebrew/Cellar/llvm/16.0.6/bin/lldb-vscode', -- adjust as needed, must be absolute path
  name = 'lldb'
}

vim.cmd[[colorscheme nord]]

-- lualine

require('lualine').setup {}

vim.cmd('COQnow')
