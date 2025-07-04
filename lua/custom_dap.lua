local M = {}

local dapui_windows = require('dapui.windows')
local dapui = require('dapui')
local dap = require('dap')

vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DapBreakpointColor', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointRejected',
  { text = '', texthl = 'DapBreakpointRejectedColor', linehl = '', numhl = '' })

vim.cmd [[highlight DapBreakpointColor guifg=#FF5F5F guibg=NULL]]
vim.cmd [[highlight DapBreakpointRejectedColor guifg=#fff guibg=NULL]]

vim.keymap.set('n', '<F6>', ':lua require("custom_dap").get_data()<CR>', { noremap = true, silent = true })

dap.adapters.codelldb = {
  type = 'server',
  port = "${port}",
  executable = {
    -- CHANGE THIS to your path!
    command = 'codelldb',
    args = { "--port", "${port}" },
    -- On windows you may have to uncomment this:
    detached = false,
  }
}

dap.configurations.cpp = {
  {
    name = "Launch file",
    type = "codelldb",
    request = "launch",
    program = function()
      return require("dap.utils").pick_file()
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
  },
}

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

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
      ["/app"] = "${workspaceFolder}/",  -- drupal
      -- ["/application/"] = "${workspaceFolder}/" -- docker
    },
    console = 'integratedTerminal'
  }
}

vim.api.nvim_create_augroup("CustomDap", {
  clear = true,
})

vim.api.nvim_create_autocmd({ "VimLeavePre" }, {
  group = "CustomDap",
  callback = function()
    for _, layout in ipairs(dapui_windows.layouts) do
      if layout:is_open() then
        dapui.close()
        break
      end
    end
  end
})

return M
