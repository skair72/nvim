local map = vim.api.nvim_set_keymap
local default_opts = {noremap = true, silent = true}

map('i', 'jk', '<Esc>', {})
map('', '<up>', ':echoe "Use k"<CR>', {noremap = true, silent = false})
map('', '<down>', ':echoe "Use j"<CR>', {noremap = true, silent = false})
map('', '<left>', ':echoe "Use h"<CR>', {noremap = true, silent = false})
map('', '<right>', ':echoe "Use l"<CR>', {noremap = true, silent = false})

-- terminal mode
map('t', '<Esc>', '<C-\\><C-n>', {noremap = true, silent = true})

map('i', '<C-J>', 'copilot#Accept("<CR>")', {expr=true, silent=true})

local function telescope(provider) return '<CMD>Telescope ' .. provider .. '<CR>' end
local wk = require("which-key")
wk.register {
  ["<Leader>"] = {
    d = { ':NvimTreeToggle<CR>', "Toggle NvimTree" },
    -- telescope
    f = {
      name = "Find",
      f     = { telescope'find_files'     , 'Files'           }, -- :find
      q     = { telescope'quickfix'       , 'Quickfix'        }, -- :copen
      l     = { telescope'loclist'        , 'Loclist'         }, -- :lopen
      t     = { telescope'tags'           , 'Tags'            }, -- :tj
      b     = { telescope'buffers'        , 'Buffers'         }, -- :ls :b
      g     = { telescope'live_grep'      , 'Grep'            },
      m     = { telescope'keymaps'        , 'Maps'            },
      M     = { telescope'marks'          , 'Marks'           },
      j     = { telescope'jumplist'       , 'Jumps'           },
      y     = { telescope'neoclip'        , 'Yanks'           },
      r     = { telescope'registers'      , 'Registers'       },
      H     = { telescope'hoogle list '   , 'Hoogle'          },
      [':'] = { telescope'command_history', 'Command history' },
      ['/'] = { telescope'search_history' , 'Search history'  },
      h     = { telescope'oldfiles'       , 'File history'    },
      ['_'] = { telescope''               , 'Providers'       },
    },
  r = {
    name = "Trouble",
    r = {':TroubleToggle workspace_diagnostics <CR>', "Toggle workspace diagnostics"},
    q = {':TroubleToggle quickfix<CR>', "Toggle quickfix" },
    l = {':TroubleToggle loclist<CR>', "Toggle loclist" },
    },
  },
  ['<esc>'] = { ':noh<CR>', 'Remove search highlights' },
}
