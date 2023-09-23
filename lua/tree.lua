-- OR setup with some options
require("nvim-tree").setup({
	sort_by = "case_sensitive",
	open_on_setup = true,
	reload_on_bufenter = true,
	respect_buf_cwd = false,
	sync_root_with_cwd = false,
	view = {
		adaptive_size = true,
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
