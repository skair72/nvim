return function()
  local wk = require("which-key")

  local function custom_on_attach(client, bufnr)
    local opts = { noremap = true, silent = true, buffer = bufnr }
    local function buf_keymap(km) wk.register(km, opts) end

    -- keymaps
    buf_keymap {
      ['<C-e>'] = { ':lua vim.diagnostic.open_float(0, {scope="line"})<CR>', 'Show diagnostics' },
      K = { ':lua vim.lsp.buf.hover()<CR>', 'Hover' },
      g = {
        ['['] = { ':lua vim.diagnostic.goto_prev()<CR>', 'Previous diagnostic' },
        [']'] = { ':lua vim.diagnostic.goto_next()<CR>', 'Next diagnostic' },
        d = { ':lua vim.lsp.buf.definition()<CR>', 'Go to definition' },
        D = { ':lua vim.lsp.buf.declaration()<CR>', 'Go to declaration' },
        i = { ':lua vim.lsp.buf.implementation()<CR>', 'Go to implementation' },
      },
      ["<Leader>"] = {
        ['fs'] = { ':lua vim.lsp.buf.workspace_symbol()<CR>', 'LSP Symbol' },
        l = {
          name = "+LSP",
          k = { ':lua vim.lsp.buf.signature_help()<CR>', 'Signature help' },
          R = { ':lua vim.lsp.buf.rename()<CR>', "Rename" },
          a = { ':lua vim.lsp.buf.code_action()<CR>', "Codeactions" },
          c = {
            name = "+codelens",
            c = { ':lua vim.lsp.codelens.run()<CR>', 'Run' },
            r = { ':lua vim.lsp.codelens.refresh()<CR>', 'Refresh' },
          },
          i = { ':lua vim.lsp.buf.implementation()<CR>', 'Implementation' },
          r = { ':lua vim.lsp.buf.references()<CR>', 'References' },
          s = {
            name = "+set",
            l = { ':lua vim.diagnostic.set_loclist()<CR>', 'Loclist' },
            q = { ':lua vim.diagnostic.set_qflist()<CR>', 'Quickfix list' },
          },
          t = { ':lua vim.lsp.buf.type_definition()<CR>', 'Type definition' },
          w = {
            name = "+workspace",
            a = { ':lua vim.lsp.buf.add_workspace_folder()<CR>', 'Add folder' },
            l = { ':lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', 'List folders' },
            r = { ':lua vim.lsp.buf.remove_workspace_folder()<CR>', 'Remove folder' },
          },
          f = { ':lua vim.lsp.buf.formatting()<CR>', 'Formatting' }
        }
      }
    }
  end

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      'documentation',
      'detail',
      'additionalTextEdits',
    }
  }

  local lsp_installer_servers = require('nvim-lsp-installer.servers')
  local servers = {
    'sumneko_lua',
    'pyright',
    'rust_analyzer',
    'dockerls',
    'graphql',
    'yamlls',
    'tsserver',
  }

  local enhance_server_opts = {
    ["sumneko_lua"] = function(opts)
      local runtime_path = vim.split(package.path, ';')
      table.insert(runtime_path, "lua/?.lua")
      table.insert(runtime_path, "lua/?/init.lua")
      opts.settings = {
        Lua = {
          runtime = {
            version = 'LuaJIT',
            path = runtime_path,
          },
          diagnostics = {
            globals = {'vim'},
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
          },
          telemetry = {
            enable = false,
          },
        },
      }
    end,
    ["yamlls"] = function(opts)
      opts.settings ={
        yaml = {
          schemas = {
            ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"] = "/*.k8s.yaml",
          }
        }
      }
    end,
  }

  for _, server_name in pairs(servers) do
    local server_available, server = lsp_installer_servers.get_server(server_name)
    if server_available then
      if not server:is_installed() then
        print("Installing " .. server.name)
        server:install()
      end

      local opts = {
        on_attach = custom_on_attach,
        capabilities = capabilities,
        flags = {
          debounce_text_changes = 150,
        },
      }
      if enhance_server_opts[server.name] then
        -- Enhance the default opts with the server-specific ones
        enhance_server_opts[server.name](opts)
      end
      server:setup(opts)
    end
  end
end
