require("keybinds")
require("options")
require("packer_config")
require("tele")
require("tree")
require("treesitter_conf")
require("harpoon_conf")
require("custom_commands")
-- require'nvim-web-devicons'.setup()
-- vim.cmd[[colorscheme catppuccin-mocha]]
vim.cmd([[colorscheme kanagawa]])


local dap = require('dap')

dap.adapters.php = {
  type = 'executable',
  command = 'node',
  args = { '/home/ron/.config/nvim/vscode-php-debug/out/phpDebug.js' }

}

dap.configurations.php = {
  {
    type = 'php',
    request = 'launch',
    name = 'Listen for Xdebug',
    port = "9003",
    log = false,
    pathMappings = {
      ["/app/"] = "${workspaceFolder}/"
    }
  }
}
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

if not configs.my_scss_lsp then
  configs.my_scss_lsp = {
    default_config = {
      cmd = { '/home/ron/programs/scss-lsp-rust/target/debug/scss-lsp' },
      filetypes = { 'css', 'scss' },
      root_dir = function(fname)
        return require("lspconfig").util.root_pattern('.git')(fname)
      end
    },
  }
end

lsp.setup()
require("lspconfig").drupal.setup { autostart = true }
require("lspconfig").my_scss_lsp.setup { autostart = true }

vim.diagnostic.config({
  virtual_text = true,
})
-- vim.cmd([[highlight HighlightedLineNr1 guifg=Yellow ctermfg=3]])
-- vim.cmd([[highlight HighlightedLineNr2 guifg=Green ctermfg=2]])
-- vim.cmd([[highlight HighlightedLineNr3 guifg=Cyan ctermfg=6]])
-- vim.cmd([[highlight HighlightedLineNr4 guifg=Blue ctermfg=4]])
-- vim.cmd([[highlight HighlightedLineNr5 guifg=Magenta ctermfg=5]])
-- vim.cmd([[highlight HighlightedLineNr5 guifg=Magenta ctermfg=5]])
-- vim.cmd([[highlight HighlightedLineNr4 guifg=Blue ctermfg=4]])
--
-- local mason = require ("mason-registry")
-- mason.get_package("stylint").get_install_path
local util = require "formatter.util"
require("formatter").setup {
  -- Enable or disable logging
  logging = true,
  -- Set the log level
  log_level = vim.log.levels.WARN,
  -- All formatter configurations are opt-in
  filetype = {
    php =
        function()
          return {
            exe = "/home/ron/.config/composer/vendor/squizlabs/php_codesniffer/bin/phpcbf",
            args = {
              "--standard=Drupal",
              "--extensions=php,module,inc,install,test,profile,theme,css,info,txt,md,yml",
              util.get_current_buffer_file_path(),
            },
            stdin = false,
          }
        end,
    css = require("formatter.filetypes.css").cssbeautify,
    scss = require("formatter.defaults.prettierd"),
    rust = require("formatter.filetypes.rust").rustfmt
  }
}

require("custom_snippets")
vim.cmd([[
  augroup FormatAutogroup
    autocmd!
    autocmd User FormatterPost checktime
  augroup END
]])

-- local format_group = vim.api.nvim_create_augroup("FormatAutogroup", { clear = false })
-- vim.api.nvim_create_autocmd("User", {
--   group = format_group,:execute "helptags " . substitute(system('opam config var share'),'\n$','','''') .  "/merlin/vim/doc"
--   command = "checktime",
-- })
require("luasnip.loaders.from_vscode").lazy_load({ paths = { "./drupal-smart-snippets/" } })
require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_snipmate").lazy_load()
