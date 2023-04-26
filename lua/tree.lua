-- OR setup with some options
require("nvim-tree").setup({
	sort_by = "case_sensitive",
	open_on_setup = true,
	reload_on_bufenter = true,
	respect_buf_cwd = false,
  sync_root_with_cwd = false,
	view = {
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
			},
		},
	},
	renderer = {
		group_empty = true,
	},
	filters = {
		dotfiles = true,
	},
})
