require("options")
require("packer_config")
require("tele")
require("tree")
require("treesitter_conf")
require("harpoon_conf")
require("custom_commands")
require("lsp_conf")
require("keybinds")
-- require'nvim-web-devicons'.setup()
-- vim.cmd[[colorscheme catppuccin-mocha]]

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
      ["/app/"] = "${workspaceFolder}/", -- drupal
      -- ["/application/"] = "${workspaceFolder}/" -- docker
    }
  }
}
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
