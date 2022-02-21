local cmd = vim.cmd             -- execute Vim commands
local g = vim.g                 -- global variables
local opt = vim.opt             -- global/buffer/windows-scoped options

------ Setup python ------
g.loaded_python_provider = 0 -- Disable python 2
g.python3_host_prog = '/Users/skair/.pyenv/versions/3.10.2/bin/python'

------ Trailing spaces ------
g.better_whitespace_ctermcolor = 'red'
g.better_whitespace_guicolor = '#516074'
g.better_whitespace_enabled = 1

------ Copilot ------
g.copilot_no_tab_map = true

------ General ------
opt.encoding = 'utf-8'
opt.number = true
opt.swapfile = false
opt.autowrite = true
opt.scrolloff = 7
opt.colorcolumn = '120'
opt.clipboard = 'unnamedplus'
opt.updatetime = 100
opt.spelllang = { 'en_us', 'ru' }
opt.splitright = true
opt.splitbelow = true
opt.showmode = false

------ Style ------
local theme = 'nightfox'
require('nightfox').load(theme)
require('lualine').setup {
  options = {
    theme = theme
  }
}

------ Tabs and margins ------
cmd([[
filetype indent plugin on
syntax on
]])
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true

-- don't auto commenting new lines
cmd [[au BufEnter * set fo-=c fo-=r fo-=o]]
-- remove line lenght marker for selected filetypes
cmd [[autocmd FileType text,html,xhtml setlocal cc=0]]
-- 2 spaces for selected filetypes
cmd([[
autocmd FileType xml,html,xhtml,css,scss,javascript,lua,yaml,htmljinja setlocal shiftwidth=2 tabstop=2
]])

------ Tests -------
cmd [[let test#strategy = "neovim"]]

------ LSP ------
local lsp_installer_servers = require('nvim-lsp-installer.servers')

local servers = {
  'sumneko_lua',
  'pyright',
  'rust_analyzer',
  'dockerls',
  'graphql',
  'yamlls'
}

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")
