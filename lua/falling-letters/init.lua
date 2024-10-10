-- require("plenary.reload").reload_module("falling-letters")
local M = {}

local print_table = function(table)
  vim.print(vim.inspect(table))
end

M.hl_namespace = vim.api.nvim_create_namespace("falling_letters")

M.get_dominant_hl_group = function(buffer, i, j)
  local captures = vim.treesitter.get_captures_at_pos(buffer, i - 1, j - 1)
  for c = #captures, 1, -1 do
    if captures[c].capture ~= "spell" and captures[c].capture ~= "@spell" then
      return "@" .. captures[c].capture
    end
  end
  return ""
end

M.grid = nil
M.running = true
M.original_buffer = nil
M.buffers = nil
M.count = 0
M.window_id = nil

M.update = function()
  M.move()
  local render_to = M.buffers[M.count % 2 + 1]
  M.render(render_to)
  M.count = M.count + 1

  if M.running then
    vim.defer_fn(function()
      M.update()
    end, 100)
  end
end

M.move = function()
  local max_width = #M.grid[1]
  local height = #M.grid
  local x = 1
  local y = 1

  for i = 1, 10 do
    while true do
      x = math.random(1, max_width)
      y = math.random(1, height)
      if M.grid[y][x] ~= " " then
        break
      end
    end

    pcall(function()
      local direction_x = math.random(-1, 1)
      local direction_y = math.random(-1, 1)
      local swap = M.grid[y][x]
      if M.grid[y + direction_y][x + direction_x] == nil then
        return
      end
      M.grid[y][x] = M.grid[y + direction_y][x + direction_x]
      M.grid[y + direction_y][x + direction_x] = swap
    end)
  end

  -- for i = #grid - 1, 1, -1 do
  --   for j = 1, #grid[i] do
  --     pcall(function()
  --       local swap = grid[i][j]
  --       grid[i][j] = grid[i + 1][j]
  --       grid[i + 1][j] = swap
  --     end)
  --   end
  -- end
end

M.render = function(buffer)
  for i = 1, #M.grid do
    local line = ""
    for j = 1, #M.grid[i] do
      line = line .. M.grid[i][j].char
    end
    vim.api.nvim_buf_set_lines(buffer, i - 1, i, false, { line })
    -- vim.api.nvim_buf_clear_namespace(buffer, hl_namespace, 0, -1)
    for j = 1, #M.grid[i] do
      vim.api.nvim_buf_add_highlight(buffer, M.hl_namespace, M.grid[i][j].hl_group, i - 1, j - 1, j)
    end
  end
  -- vim.api.nvim_win_set_buf(M.window_id, buffer)
  vim.api.nvim_set_current_buf(buffer)
end

M.start = function()
  M.grid = {}
  M.original_buffer = vim.api.nvim_get_current_buf()
  local filetype = vim.bo.filetype
  local height = vim.api.nvim_win_get_height(0)
  local width = vim.api.nvim_win_get_width(0)

  local empty_lines = {}
  local top_line = vim.fn.winsaveview().topline
  local current_lines = vim.api.nvim_buf_get_lines(0, top_line - 1, top_line + height, false)
  M.buffers = {
    vim.api.nvim_create_buf(false, true),
    vim.api.nvim_create_buf(false, true),
  }

  for i = 1, #current_lines do
    M.grid[i] = {}
    for j = 1, width do
      M.grid[i][j] = { char = " ", hl_group = "" }
    end
  end

  for i = 1, #current_lines do
    empty_lines[i] = string.rep(" ", width + 1)
  end

  vim.bo[M.buffers[1]].ul = 0
  vim.bo[M.buffers[2]].ul = 0
  vim.api.nvim_buf_set_lines(M.buffers[1], 0, -1, false, empty_lines)
  vim.api.nvim_buf_set_lines(M.buffers[2], 0, -1, false, empty_lines)

  for idx, line in ipairs(current_lines) do
    for i = 1, #line do
      local character = line:sub(i, i)
      local hl_group = M.get_dominant_hl_group(M.original_buffer, idx + top_line - 1, i)
      M.grid[idx][i] = { char = character, hl_group = hl_group }
    end
  end

  M.count = 0
  vim.defer_fn(M.update, 200)
  vim.api.nvim_buf_set_keymap(M.buffers[1], "n", "q", ":lua require('falling-letters').stop()<CR>",
    { noremap = true, silent = true })

  vim.api.nvim_buf_set_keymap(M.buffers[2], "n", "q", ":lua require('falling-letters').stop()<CR>",
    { noremap = true, silent = true })
end

M.stop = function()
  M.running = false
  vim.api.nvim_set_current_buf(M.original_buffer)
end

M.start()
return M
