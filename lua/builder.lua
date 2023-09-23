-- require("plenary.reload").reload_module("builder")
local Job = require("plenary.job")
local a = require 'plenary.async'

local sender, receiver = a.control.channel.mpsc()

M = {}

M.bufnr = 1
M.winnr = 1
M.initialized = false
M.job = nil

M.hide_window = function()
  vim.api.nvim_win_hide(M.winnr)
end

M.show_window = function()
  if vim.api.nvim_win_is_valid(M.winnr) then
    M.focus_window()
  else
    M.winnr = vim.api.nvim_open_win(M.bufnr, true,
      { relative = "win", row = 10, col = 10, width = 40, height = 20, bufpos = { -1, -1 } })
    M.focus_window()
  end
end

M.focus_window = function()
  if M.winnr ~= nil then
    vim.api.nvim_set_current_win(M.winnr)
  end
end

M.start_job = function()
  M.job = Job:new(
  ---@diagnostic disable-next-line: missing-fields
    {
      command = 'lando',
      args = { "npm", "run", "watch" },
      on_stdout = function(j, stdout)
        sender.send(stdout)
      end,
      on_stderr = function(j, stderr)
        sender.send(stderr)
      end,
      on_exit = function(j, exit_value)
        sender.send("Exiting job")
      end
    }):start()
end

M.stop_job = function()
  M.job.shutdown(M.job)
end

M.setup = function()
  if M.initialized == false then
    M.initialized = true
    M.bufnr = vim.api.nvim_create_buf(true, false)
    M.show_window()
    M.listener()
    M.start_job()
  else
    M.show_window()
  end
end

M.listener = function()
  ---@diagnostic disable-next-line: missing-parameter
  a.run(function()
    while true do
      local value = receiver.recv()
      -- local lines = vim.split(tostring(value), "\n")
      vim.schedule(function()
        vim.api.nvim_buf_set_lines(M.bufnr, -1, -1, false, { value })
        vim.api.nvim_buf_call(M.bufnr, function()
          vim.cmd([[norm G]])
        end)
        -- if M.winnr == not nil then
        --   vim.api.cmd
        -- end
      end
      )
    end
  end
  )
end

return M
