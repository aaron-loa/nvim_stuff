local M = {}

local dapui_windows = require('dapui.windows')
local dapui = require('dapui')
local dap = require('dap')

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local cached_result = ""


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
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end ,
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
      -- TODO automatize this
      ["/app/"] = "${workspaceFolder}/", -- drupal
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
      for _, win in ipairs(layout.opened_wins) do
        -- if a windows is open close everything
        -- this helps with session manager plugins
        dapui.close()
        break
      end
    end
  end
})

return M
