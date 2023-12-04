-- OR setup with some options
--

local width_ratio = 0.5
local heigth_ratio = 0.8

local function set_win()
  local lines = vim.opt.lines:get() - vim.opt.cmdheight:get()
  local columns = vim.opt.columns:get()

  local columns_width = math.floor(columns * width_ratio)
  local leftover_width = columns - columns_width
  local start_column = math.floor(leftover_width / 2)
  local window_h = math.floor(lines * heigth_ratio)
  local center_y = math.floor(((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get())
  return {
    relative = "editor",
    border = "rounded",
    width = columns_width,
    height = window_h,
    row = center_y,
    col = start_column,
  }
end

local tree = require("nvim-tree")
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  open_on_setup = true,
  reload_on_bufenter = true,
  respect_buf_cwd = false,
  sync_root_with_cwd = false,
  actions = {
    open_file = {
      resize_window = true
    }
  },
  view = {
    float = {
      enable = true,
      quit_on_focus_loss = true,
      open_win_config = function() return set_win() end
    },
    preserve_window_proportions = false,
    adaptive_size = false,
    mappings = {
      list = {
        { key = "-", action = "dir_up" },
        { key = "r", action = "rename_basename" },
        { key = "R", action = "rename" },
        { key = "e", action = "edit" },
        { key = "%", action = "create" },
        { key = "G", action = "toggle_git_ignored" },
        { key = "d", action = "trash" },
        { key = "D", action = "remove" },
        { key = "v", action = "toggle_mark" },
        { key = "U", action = "refresh" },
        { key = "f", action = "" },
        { key = "F", action = "live_filter" },
      },
    },
  },
  renderer = {
    group_empty = false,
  },
  filters = {
    dotfiles = true,
  },
  diagnostics = {
    enable = true,
    show_on_dirs = true,
    show_on_open_dirs = true,
    debounce_delay = 500,
    severity = {
      min = vim.diagnostic.severity.HINT,
      max = vim.diagnostic.severity.ERROR,
    },
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
})

local tree_api = require("nvim-tree")
local tree_view = require("nvim-tree.view")

vim.api.nvim_create_augroup("NvimTreeResize", {
  clear = true,
})

vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = "NvimTreeResize",
  callback = function()
    if tree_view.is_visible() then
      tree_view.close()
      print("close")
      tree_api.open()
    end
  end
})
