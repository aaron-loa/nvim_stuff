require("neodev").setup({})

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
  vim.keymap.set('n', 'K',  function() vim.lsp.buf.hover() end)
  vim.keymap.set('n', 'gD', function() vim.lsp.buf.definition() end)
  vim.keymap.set('n', '<leader>gd', function() vim.lsp.buf.declaration() end)
  vim.keymap.set('n', 'gi', function() vim.lsp.buf.implementation() end)
  vim.keymap.set('n', 'go', function() vim.lsp.buf.type_definition() end)
  vim.keymap.set('n', 'gr',  function() vim.lsp.buf.references() end)
  vim.keymap.set('n', 'gs',  function() vim.lsp.buf.signature_help() end)
  vim.keymap.set('n', '<F2>', function() vim.lsp.buf.rename() end)
  vim.keymap.set('n', '<F4>', function() vim.lsp.buf.code_action() end)
  vim.keymap.set('x', '<F4>', function() vim.lsp.buf.range_code_action() end)
  vim.keymap.set('n', 'gl', function() vim.lsp.diagnostic.open_float() end)
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

require("lspconfig").rust_analyzer.setup({
  on_init = function() print("rustanalyzer init") end
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
-- require("lspconfig").my_scss_lsp.setup { autostart = true }

vim.diagnostic.config({
  virtual_text = true,
})
