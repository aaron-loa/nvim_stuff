local lsp_zero = require("lsp-zero")

require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {},
  handlers = {
    lsp_zero.default_setup,
  },
})

lsp_zero.on_attach(function(client, bufnr)
  local opts = { buffer = bufnr, remap = false }
  vim.keymap.set("n", "gn", function()
    vim.diagnostic.goto_next()
  end, opts)
  vim.keymap.set("n", "gb", function()
    vim.diagnostic.goto_prev()
  end, opts)
  vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)

  vim.keymap.set("n", "gd", function() require("utils").CustomGoToDefinition() end)
  vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end)
  vim.keymap.set('n', 'gD', function() vim.lsp.buf.definition() end)
  vim.keymap.set('n', '<leader>gd', function() vim.lsp.buf.declaration() end)
  vim.keymap.set('n', 'gi', function() vim.lsp.buf.implementation() end)
  vim.keymap.set('n', 'go', function() vim.lsp.buf.type_definition() end)
  vim.keymap.set('n', 'gr', function() vim.lsp.buf.references() end)
  vim.keymap.set('n', 'gs', function() vim.lsp.buf.signature_help() end)
  vim.keymap.set('n', '<F2>', function() vim.lsp.buf.rename() end)
  vim.keymap.set('n', '<F4>', function() vim.lsp.buf.code_action() end)
  vim.keymap.set('x', '<F4>', function() vim.lsp.buf.range_code_action() end)
  vim.keymap.set('n', 'gl', function() vim.diagnostic.open_float() end)
end)

-- local config = {
--   settings = {
--     Lua = {
--       runtime = {
--         path = vim.api.nvim_get_runtime_file("", true),
--       },
--       workspace = {
--         -- Make the server aware of Neovim runtime files
--         library = {
--           vim.api.nvim_get_runtime_file("", true),
--         }
--       },
--     }
--   }
-- }

-- require("lspconfig").lua_ls.setup(lsp.nvim_lua_ls())
local configs = require 'lspconfig.configs'

-- require 'lspconfig'.lua_ls.setup {
--   on_init = function(client)
--     local path = client.workspace_folders[1].name
--     if not vim.loop.fs_stat(path .. '/.luarc.json') and not vim.loop.fs_stat(path .. '/.luarc.jsonc') then
--       client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
--         Lua = {
--           runtime = {
--             version = 'LuaJIT'
--           },
--           -- Make the server aware of Neovim runtime files
--           workspace = {
--             checkThirdParty = "enable",
--             library = {
--               vim.env.VIMRUNTIME,
--               "/home/ron/.luarocks/lib",
--               "/usr/lib/lua",
--               -- "${3rd}/luv/library"
--               -- llk
--               -- "${3rd}/busted/library",
--             }
--             -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
--             -- library = vim.api.nvim_get_runtime_file("", true)
--           }
--         }
--       })
--     end
--     return true
--   end
-- }

require("lspconfig").clangd.setup({
  on_attach = function(client, bufnr)
    client.server_capabilities.offsetEncoding = { "utf-8" }
  end,
 cmd = { "clangd", "--offset-encoding=utf-16"} 
})
require("lspconfig").rust_analyzer.setup({
  on_init = function() print("rustanalyzer init") end
})


local turn_off_specific_handlers = {
  ['textDocument/documentSymbol'] = function() end,
  ['workspace/symbol'] = function() end,
}
require("lspconfig").cssls.setup({
  on_attach = function(client, bufnr)
    client.server_capabilities.documentSymbolProvider = nil
    client.server_capabilities.workspaceSymbolProvider = nil
    client.server_capabilities.referencesProvider = nil
  end,
})

require("lspconfig").tailwindcss.setup({
  on_attach = function(client, bufnr)
    client.server_capabilities.documentSymbolProvider = nil
    client.server_capabilities.workspaceSymbolProvider = nil
    client.server_capabilities.referencesProvider = nil
  end,
})

require("lspconfig").intelephense.setup({
  filetypes = { "php", "inc", "module", "yml", "install", "phtml", "theme" },
  on_attach = function() print("loaded intelephense") end,
  settings = {
    intelephense = {
      files = {
        associations = {
          "*.inc",
          "*.theme",
          "*.install",
          "*.module",
          "*.profile",
          "*.php",
          "*.phtml"
        }
      },
      environment = {
        includePaths = {
          "./web/core/includes"
        }
      }
    }
  }
})

if not configs.drupal then
  configs.drupal = {
    default_config = {
      cmd = { '/home/ron/programs/drupal-lsp/drupal-lsp' },
      filetypes = { 'php' },
      root_dir = function(fname)
        return require("lspconfig").util.root_pattern('composer.json', '.git')(fname)
      end
    },
  }
end

if not configs.custom_scss then
  configs.custom_scss = {
    default_config = {
      cmd = { '/home/ron/programs/scss-lsp/scss-lsp' },
      filetypes = { 'scss' },
      autostart = true,
      root_dir = function(fname)
        return require("lspconfig").util.root_pattern('composer.json', '.git')(fname)
      end
    },
  }
end

-- if not configs.my_scss_lsp then
--   configs.my_scss_lsp = {
--     default_config = {
--       cmd = { '/home/ron/programs/scss-lsp-rust/target/debug/scss-lsp' },
--       filetypes = { 'css', 'scss' },
--       root_dir = function(fname)
--         return require("lspconfig").util.root_pattern('.git')(fname)
--       end
--     },
--   }
-- end

lsp_zero.setup()
require("lspconfig").drupal.setup { autostart = true }
require("lspconfig").custom_scss.setup { autostart = true }
-- require("lspconfig").my_scss_lsp.setup { autostart = true }

vim.diagnostic.config({
  virtual_text = true,
})
