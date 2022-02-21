return function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
  vim.opt.completeopt = {'menu', 'menuone', 'noselect'}
  -- luasnip setup
  local luasnip = require('luasnip')
  -- nvim-cmp setup
  local cmp = require('cmp')
  local lspkind = require('lspkind')
  cmp.setup {
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    formatting = {
      format = function(entry, vim_item)
        vim_item.kind = lspkind.presets.default[vim_item.kind]
        return vim_item
      end
    },
    completion = {
      trim_match = false,
    },
    mapping = {
      ['<C-p>'] = cmp.mapping.select_prev_item(),
      ['<C-n>'] = cmp.mapping.select_next_item(),
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.close(),
      ['<CR>'] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      }),
      ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
      ['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 's' })
    },
    sources = {
      { name = 'cmp_tabnine' },
      -- { name = 'copilot' },
      {
        name = 'buffer', option = {
        get_bufnrs = function()
          return vim.api.nvim_list_bufs()
        end
        },
      },
      { name = 'nvim_lsp' },
      { name = 'path' },
      { name = 'luasnip' },
    },
    enabled = function ()
      return vim.o.bt == ''
    end
  }
  cmp.setup.cmdline(':', {
    sources = {
      { name = 'cmdline' }
    }
  })
  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
  })
end
