local execute = vim.api.nvim_command
local install_path = vim.fn.stdpath("config") .. "/pack/packer/opt/packer.nvim"

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
	execute("packadd packer.nvim")
end

require("packer").startup(function()
	use("/sbdchd/neoformat")
	use("EdenEast/nightfox.nvim")
	use("L3MON4D3/LuaSnip") -- Snippet engine
	use("ThePrimeagen/harpoon")
	use("ThePrimeagen/vim-be-good") --trash game
	use("ethanholz/nvim-lastplace") -- good stuff
	use("felipec/vim-sanegx") -- fixes gx
	use("folke/tokyonight.nvim")
	use("gaborvecsei/memento.nvim")
	use("hrsh7th/cmp-buffer") -- Completion source
	use("hrsh7th/cmp-nvim-lsp") -- Completion source
	use("hrsh7th/nvim-cmp") -- Autocomplete engine
	use("kdheepak/lazygit.nvim") -- <leader>gg
	use("lukas-reineke/indent-blankline.nvim") --blank lines
	use("mbbill/undotree") --<F5>
	use("norcalli/nvim-colorizer.lua")
	use("nvim-treesitter/nvim-treesitter-context")
	use("nvim-treesitter/playground")
	use("saadparwaiz1/cmp_luasnip") -- Completion source
	use("sainnhe/sonokai") --colorscheme
	use("tomasiser/vim-code-dark") --colorscheme
	use("tomtom/tcomment_vim")
	use("tpope/vim-surround")
	use("wbthomason/packer.nvim")
	use({ "catppuccin/nvim", as = "catppuccin" }) --colorscheme
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
	use({
		"lewis6991/gitsigns.nvim",
		tag = "release", -- To use the latest release (do not use this if you run Neovim nightly or dev builds!)
	})
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = false },
	})
	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.0",
		-- or                            , branch = '0.1.x',
		requires = { { "nvim-lua/plenary.nvim" } },
	})
	use({
		"VonHeikemen/lsp-zero.nvim",
		requires = {
			-- LSP Support
			{ "neovim/nvim-lspconfig" },
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },

			-- Autocompletion
			{ "hrsh7th/nvim-cmp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-nvim-lua" },

			-- Snippets
			{ "L3MON4D3/LuaSnip" },
			-- Snippet Collection (Optional)
			{ "rafamadriz/friendly-snippets" },
		},
	})
	use({
		"ahmedkhalf/project.nvim",
		config = function()
			require("project_nvim").setup({
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			})
		end,
	})
	use({
		"nvim-tree/nvim-tree.lua",
		requires = {
			"nvim-tree/nvim-web-devicons", -- optional, for file icons
		},
		tag = "nightly", -- optional, updated every week. (see issue #1193)
	})
	use({ -- :AerialOpen
		"stevearc/aerial.nvim",
		config = function()
			require("aerial").setup()
		end,
	})
	use({ -- preview definition
		"rmagatti/goto-preview",
		config = function()
			require("goto-preview").setup()
		end,
	})
	use({ -- clipboard manager
		"AckslD/nvim-neoclip.lua",
		requires = {
			{ "kkharji/sqlite.lua" },
			{ "nvim-telescope/telescope.nvim" },
		},
		config = function()
			require("neoclip").setup()
		end,
	})
	use({
		"Pocco81/auto-save.nvim",
		config = function()
			require("auto-save").setup()
		end,
	})
	use({ "michaelb/sniprun", run = "bash ./install.sh" })
end)

require("neoclip").setup({ enable_persistent_history = true, default_register = "+" })
require("gitsigns").setup()
require("lualine").setup()
require("auto-save").setup()
require'treesitter-context'.setup()

require("telescope").load_extension("projects")
require("telescope").load_extension("neoclip")
require("telescope").load_extension("macroscope")
require("telescope").setup({
	pickers = {
		colorscheme = {
			enable_preview = true,
		},
	},
})

require("colorizer").setup()
require("nvim-lastplace").setup({})
require("goto-preview").setup({ default_mappings = true })
require("sniprun").setup({ display = { "TempFloatingWindow" } })
