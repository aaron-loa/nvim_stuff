
require("neodev").setup({})

local lsp = require("lsp-zero")
lsp.preset("recommended")

lsp.on_attach(function(client, bufnr)
  local opts = { buffer = bufnr, remap = false }
  vim.keymap.set("n", "gn", function()
    vim.diagnostic.goto_next()
  end, opts)
  vim.keymap.set("n", "gb", function()
    vim.diagnostic.goto_prev()
  end, opts)
  vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
  -- vim.keymap.set("n", "K", function()
  --   vim.diagnostic.overrides()
  -- end, opts)
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

lsp.setup()
require("lspconfig").drupal.setup { autostart = true }
-- require("lspconfig").my_scss_lsp.setup { autostart = true }

vim.diagnostic.config({
  virtual_text = true,
})
