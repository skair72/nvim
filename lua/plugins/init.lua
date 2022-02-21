local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system(
    {'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path}
  )
  print("Installing packer close and reopen Neovim...")
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost */nvim/lua/plugins/init.lua source <afile> | PackerSync
  augroup end
]])

local packer = require('packer')

-- vim.cmd(string.format([[
-- autocmd User PackerCompileDone call system(['/usr/local/bin/luajit', '-bg', '%s', '%s'])
-- ]], packer.config.compile_path, packer.config.compile_path))

return packer.startup({function(use)
  use {
    'lewis6991/impatient.nvim',
   -- rocks = 'mpack'
  }
  use 'wbthomason/packer.nvim'
  use { 'dstein64/vim-startuptime', cmd = { 'StartupTime' } }

  -- Useful lua functions used by lots of plugins
  use 'nvim-lua/plenary.nvim'
  use 'nvim-lua/popup.nvim'

  ------ Wakatime ------
  use 'wakatime/vim-wakatime'

  ------ Fuzzy search ------
  use {
    'nvim-telescope/telescope.nvim',
    requires = { 'nvim-lua/plenary.nvim' }
  }

  ------ Trailing spaces ------
  use 'ntpeters/vim-better-whitespace'

  ------ Style ------
  use 'EdenEast/nightfox.nvim'
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = require('plugins.statusline')
  }

  ------ Git ------
  use 'tpope/vim-fugitive'
  use 'airblade/vim-gitgutter'

  ------ LSP ------
  use 'neovim/nvim-lspconfig'
  use {
    'williamboman/nvim-lsp-installer',
    config = require('modules.lsp')
  }

  ------ Completion ------
  use {
    'hrsh7th/nvim-cmp',
    config = require('plugins.completion'),
    requires = {
      { 'tzachar/cmp-tabnine', run = './install.sh' },
      -- 'hrsh7th/cmp-copilot',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'onsails/lspkind-nvim',
      {
        'L3MON4D3/LuaSnip',
        'saadparwaiz1/cmp_luasnip'
      }
    }
  }

  ------ Other ------
  use 'powerman/vim-plugin-ruscmd'
  use 'ap/vim-css-color'
  use 'vim-test/vim-test'

  use {
    "folke/which-key.nvim",
    config = require('plugins.which-key')
  }

  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons',
    },
    config = require('plugins.nvim-tree')
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = require('plugins.treesitter')
  }

  use {
    'j-hui/fidget.nvim',
    config = require('plugins.fidget')
  }

  use {
    'folke/trouble.nvim',
    config = require('plugins.trouble'),
  }

  -- use 'petobens/poet-v'
  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require('packer').sync()
  end
end,
config = {
  display = {
    open_fn = function()
      return require('packer.util').float({ border = 'single' })
    end
  }
}})
