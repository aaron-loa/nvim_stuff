local builtin = require('telescope.builtin')

local function find_directory_and_focus()
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local function open_nvim_tree(prompt_bufnr, _)

    actions.select_default:replace(function()
      local api = require("nvim-tree.api")
      actions.close(prompt_bufnr)
      local selection = action_state.get_selected_entry()
      api.tree.open()
      api.tree.find_file(selection.cwd .. "/" .. selection.value)
    end)
    return true
  end

  require("telescope.builtin").find_files({
    find_command = { "fd", "--type", "directory", "--hidden", "--exclude", ".git/*" },
    attach_mappings = open_nvim_tree,
  })
end
local live_grep_args_shortcuts = require("telescope-live-grep-args.shortcuts")


vim.keymap.set("n", "fd", find_directory_and_focus)
vim.keymap.set('n', '<leader>fv', live_grep_args_shortcuts.grep_word_under_cursor, {})
vim.keymap.set('v', '<leader>fv', live_grep_args_shortcuts.grep_visual_selection, {})
vim.keymap.set('n', '<leader>fl', ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", {})
vim.keymap.set('n', '<leader>fL', [[:lua require('telescope').extensions.live_grep_args.live_grep_args({default_text='--no-ignore '})<CR>]], {})
vim.keymap.set('n', '<leader>ff', builtin.git_files, {})
vim.keymap.set('n', '<leader>fF', ":Telescope find_files no_ignore=true<CR>", {})
vim.keymap.set('n', '<leader>cs', ":lua require('telescope.builtin').colorscheme({enable_preview = true})<CR>", {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fe', find_directory_and_focus, {})
vim.keymap.set('n', '<leader>fs', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
