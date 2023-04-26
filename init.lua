require("keybinds")
require("options")
require("packer_config")
require("tele")
require("tree")
require("treesitter_conf")
require("harpoon_conf")
require("custom_commands")

-- require'nvim-web-devicons'.setup()
 -- same as `override` but specifically for overrides by extension
 -- takes effect when `strict` is true
-- vim.cmd[[colorscheme catppuccin-mocha]]
vim.cmd([[colorscheme carbonfox]])
local lsp = require("lsp-zero")
lsp.preset("recommended")

lsp.nvim_workspace()
lsp.on_attach(function(client, bufnr)
	local opts = { buffer = bufnr, remap = false }

	vim.keymap.set("n", "gn", function()
		vim.diagnostic.goto_next()
	end, opts)
vim.keymap.set("n", "gb", function()
		vim.diagnostic.goto_prev()
	end, opts)
end)


lsp.setup_nvim_cmp({
	mapping,
})
lsp.setup()
