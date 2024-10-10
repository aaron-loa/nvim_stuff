-- require("plenary.reload").reload_module("diff-split-window")
local M = {}


M.buffers = { nil, nil }
M.tab_page = nil
M.left_window = nil
M.right_window = nil

M.setup_float = function()
  M.right_window = vim.api.nvim_open_win(M.get_buffers(2), true, {
    split = "right",
  })
  vim.cmd("diffthis")
end

M.get_buffers = function(i)
  assert(i == 1 or i == 2, "i must be 1 or 2 but is: " .. i)
  if M.buffers[i] == nil then
    M.buffers[i] = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_keymap(M.buffers[i], "n", "q", ":lua require('diff-split-window').close()<CR>",
      { noremap = true, silent = true })
  end
  return M.buffers[i]
end


M.open = function()
  if vim.api.nvim_get_current_tabpage() == M.tab_page then
    return
  end

  vim.schedule(function()
    if M.tab_page ~= nil and vim.api.nvim_tabpage_is_valid(M.tab_page) then
      vim.api.nvim_set_current_tabpage(M.tab_page)
      return
    end

    vim.cmd("tab split")

    M.tab_page = vim.api.nvim_get_current_tabpage()
    M.left_window = vim.api.nvim_get_current_win()

    vim.api.nvim_set_current_buf(M.get_buffers(1))
    M.setup_float()

    vim.wo[M.right_window].relativenumber = false
    vim.wo[M.left_window].relativenumber = false

    vim.schedule(function()
      vim.api.nvim_set_current_win(M.left_window)
      vim.cmd("diffthis")
    end)
  end)
end

M.close = function()
  vim.schedule(function()
    if vim.api.nvim_win_is_valid(M.right_window) then
      vim.api.nvim_win_close(M.right_window, true)
    end
    if vim.api.nvim_win_is_valid(M.left_windowleft_window) then
      vim.api.nvim_win_close(M.left_window, true)
    end
  end)
end

M.setup = function()
  vim.api.nvim_create_user_command("DiffBuffers", function()
    M.open()
  end, {})
end

return M
