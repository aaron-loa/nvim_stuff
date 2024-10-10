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
  vim.keymap.set("i", "<C-n>", function() vim.lsp.buf.completion({}) end)
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
  vim.keymap.set('x', '<F3>', function() vim.lsp.buf.range_code_action() end)
  vim.keymap.set('n', 'gl', function() vim.diagnostic.open_float() end)
end)

local configs = require 'lspconfig.configs'

require("lspconfig").clangd.setup({
  on_attach = function(client, bufnr)
    client.server_capabilities.offsetEncoding = { "utf-8" }
  end,
  cmd = { "clangd", "--offset-encoding=utf-16" }
})

-- require("lspconfig").rust_analyzer.setup({
--   on_init = function() print("rustanalyzer init") end
-- })


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
  -- on_attach = function() print("loaded intelephense") end,
  settings = {
    intelephense = {
      format = {
        braces = "k&r",
      },
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
        return require("lspconfig").util.root_pattern('.git')(fname)
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
        return require("lspconfig").util.root_pattern('.git')(fname)
      end
    },
  }
end

if not configs.drupal_rust_lsp then
  configs.drupal_rust_lsp = {
    default_config = {
      cmd = { '/home/ron/programs/drupal-lsp-rust/target/debug/drupal-lsp-rust' },
      -- cmd = { '/home/ron/programs/drupal-lsp-rust/target/release/drupal-lsp-rust' },
      filetypes = { 'php', 'yaml', 'yml' },
      autostart = true,
      root_dir = function(fname)
        return require("lspconfig").util.root_pattern('.git')(fname)
      end
    },
  }
end
if not configs.gleam then
  configs.gleam = {
    default_config = {
      -- on_attach = function(client, bufnr)
      --   client.server_capabilities.offsetEncoding = { "utf-16" }
      -- end,
      -- cmd = { '/home/ron/programs/gleam/target/debug/gleam', "lsp" },
      cmd = { 'gleam', "lsp" },
      args = 'lsp',
      filetypes = { 'gleam' },
      autostart = true,
      root_dir = function(fname)
        return require("lspconfig").util.root_pattern('.git')(fname)
      end
    },
  }
end

require("lspconfig").tsserver.setup {
  init_options = {
    plugins = {
      {
        name = '@vue/typescript-plugin',
        location = "/usr/local/lib/node_modules/@vue/language-server/lib",
        languages = { 'vue' },
      },
    },
  },
}

require("lspconfig").volar.setup {
  init_options = {
    vue = {
      hybridMode = false,
    },
    typescript = {
      tsdk = '/usr/local/lib/node_modules/typescript/lib/'
      -- Alternative location if installed as root:
      -- tsdk = '/usr/local/lib/node_modules/typescript/lib'
    }
  },
}


lsp_zero.setup()
require("lspconfig").drupal.setup { autostart = true }
require("lspconfig").custom_scss.setup { autostart = true }
-- require("lspconfig").drupal_go_lsp.setup { autostart = true }
require("lspconfig").drupal_rust_lsp.setup { autostart = true }
require("lspconfig").gleam.setup { autostart = true }

vim.diagnostic.config({
  virtual_text = true,
})
