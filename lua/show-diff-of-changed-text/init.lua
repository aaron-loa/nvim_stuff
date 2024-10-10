require("plenary.reload").reload_module("show-diff-of-changed-text")
local M = {}

M.buffers = {
  nil,
}

M.tab_page = nil
M.window = nil

M.open = function()
  local saved_file = vim.fn.readfile(vim.fn.expand("%"), "b")
  -- remove last empty line
  saved_file[#saved_file] = nil
  local filetype = vim.bo.filetype
  vim.cmd("diffthis")

  if M.window == nil or not vim.api.nvim_win_is_valid(M.window) then
    M.window = vim.api.nvim_open_win(M.get_buffers(1), true, {
      split = "right",
    })
    vim.bo[M.get_buffers(1)].filetype = filetype
  end

  vim.api.nvim_set_current_win(M.window)
  vim.cmd("diffthis")
  vim.api.nvim_buf_set_lines(M.get_buffers(1), 0, -1, false, saved_file)
end

M.get_buffers = function(i)
  assert(i == 1 or i == 2, "i must be 1 or 2 but is: " .. i)
  if M.buffers[i] == nil then
    M.buffers[i] = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_keymap(M.buffers[i], "n", "q", ":lua require('show-diff-of-changed-text').close()<CR>",
      { noremap = true, silent = true })
  end
  return M.buffers[i]
end

M.close = function()
  if M.window == nil or not vim.api.nvim_win_is_valid(M.window) then
    return
  end
  vim.cmd("diffoff")
  vim.api.nvim_win_close(M.window, true)
  M.window = nil
  vim.api.nvim_buf_delete(M.buffers[1], { force = false })
  M.buffers = { nil }
end

M.setup = function()
  vim.api.nvim_create_user_command("DiffNonSaved", function() M.open() end, {})
end

return M
