local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "mhartington/formatter.nvim",
    event = "VeryLazy",
    lazy = true,
  }, -- TODO: change this none ls
  {
    "mfussenegger/nvim-lint",
    event = "VeryLazy",
    lazy = true,
  }, -- is this good?
  {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!:).
    build = "make install_jsregexp",
    event = "VeryLazy",
    lazy = true
  },
  {
    "rafamadriz/friendly-snippets",
    event = "VeryLazy",
    lazy = true
  },
  {
    "nvim-lua/plenary.nvim",
    lazy = true
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    event = "BufEnter",
    dependencies = { { "nvim-lua/plenary.nvim" } }
  },
  "ethanholz/nvim-lastplace", -- good stuff
  "rebelot/kanagawa.nvim",
  "folke/tokyonight.nvim",
  "hrsh7th/cmp-buffer",   -- Completion source
  "hrsh7th/cmp-nvim-lsp", -- Completion source
  "hrsh7th/nvim-cmp",     -- Autocomplete engine
  {
    "NeogitOrg/neogit",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",         -- required
      "sindrets/diffview.nvim",        -- optional - Diff integration
      -- Only one of these is needed, not both.
      "nvim-telescope/telescope.nvim", -- optional
    },
    config = true,
  },
  {
    "folke/neodev.nvim",
    event = "VeryLazy",
  },
  "kdheepak/lazygit.nvim",               -- <leader>gg
  "lukas-reineke/indent-blankline.nvim", --blank lines
  "mbbill/undotree",                     --<F5>
  {
    "ray-x/lsp_signature.nvim",          -- automatic hover on function
    event = "VeryLazy",
  },
  "norcalli/nvim-colorizer.lua",
  "nvim-treesitter/nvim-treesitter-context",
  "nvim-treesitter/playground",
  "saadparwaiz1/cmp_luasnip", -- Completion source
  {
    "numToStr/Comment.nvim",
    config = function()
      require('Comment').setup()
    end,
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  {
    "lewis6991/gitsigns.nvim", -- TODO make keybinds for this
  },
  "chentoast/marks.nvim",      -- TODO learn how to use this effectively
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "kyazdani42/nvim-web-devicons", opt = false },
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.4",
    -- or                            , branch = '0.1.x',
    dependencies = { { "nvim-lua/plenary.nvim" } },
  },
  "nvim-telescope/telescope-live-grep-args.nvim",
  "github/copilot.vim",
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v2.x",
    dependencies = {
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
  },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- optional, for file icons
    },
    tag = "nightly",                 -- optional, updated every week. (see issue #1193)
  },
  {                                  -- :AerialOpen
    "stevearc/aerial.nvim",
    event = "VeryLazy",
    config = function()
      require("aerial").setup(
        {
          backends = { "treesitter", "lsp", "markdown", "man" },
        })
    end,
  },
  {                          -- preview definition
    "rmagatti/goto-preview", -- TODO  make gd always open with goto-preview if the function is a non git file
    event = "VeryLazy",
    config = function()
      require("goto-preview").setup({
        width = 80,
        height = 80,
        default_mappings = true,
      })
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    dependencies = { "mfussenegger/nvim-dap" }
  },
  { -- clipboard manager
    "AckslD/nvim-neoclip.lua",
    dependencies = {
      { "kkharji/sqlite.lua" },
      { "nvim-telescope/telescope.nvim" },
    },
    config = function()
      require("neoclip").setup()
    end,
  },
  -- use({
  --   "okuuva/auto-save.nvim",
  --   config = function()
  --     require("auto-save").setup
  --     {
  --       trigger_events = {},
  --     }
  --   end,
  -- })
  {
    "danymat/neogen",
    event = "VeryLazy",
    config = function()
      require("neogen").setup({ snippet_engine = "luasnip" })
    end,
    dependencies = "nvim-treesitter/nvim-treesitter",
    -- Uncomment next line if you want to follow only stable versions
    -- tag = "*"
  },
  {
    "folke/trouble.nvim", -- <leader>tt TODO learn how to use this
    event = "VeryLazy",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("trouble").setup({
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      })
    end,
  },
})

require("neoclip").setup({ enable_persistent_history = true, default_register = "+" })
require("gitsigns").setup()
require("lualine").setup({})
require("treesitter-context").setup()
require('dapui').setup()
require("telescope").load_extension("live_grep_args")
require("telescope").load_extension("neoclip")
-- require("telescope").load_extension("macroscope")
require("telescope").load_extension("aerial")
require 'lsp_signature'.setup()

local trouble = require("trouble.providers.telescope")
local lga_actions = require("telescope-live-grep-args.actions")

require("telescope").setup({
  extensions = {
    live_grep_args = {
      auto_quoting = false, -- enable/disable auto-quoting
    }
  },
  pickers = {
    colorscheme = {
      enable_preview = true,
    },
  },
  defaults = {
    mappings = {
      i = {
        ["<c-q>"] = trouble.open_with_trouble,
        ["<c-t>"] = lga_actions.quote_prompt({ postfix = " -t " }),
        ["<c-k>"] = lga_actions.quote_prompt()
      },
      n = { ["<c-q>"] = trouble.open_with_trouble },
    },
    file_ignore_patterns = { "node_modules", ".sql" }
  },
})

require("colorizer").setup()
require("nvim-lastplace").setup({})

require("nvim-treesitter.configs").setup({
  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  },
})

require 'marks'.setup {
  mappings = {
    set_next = "m,",
    next = "m]",
    preview = "m:",
    set_bookmark0 = "m0",
    prev = false -- pass false to disable only this default mapping
  }
}

require("goto-preview").setup({
  width = 80,
  height = 25,
  default_mappings = true,
})
require("formatter").setup {
  -- Use the special "*" filetype for defining formatter configurations on
  -- any filetype
  ["*"] = {
    -- "formatter.filetypes.any" defines default configurations for any
    -- filetype
    require("formatter.filetypes.any").remove_trailing_whitespace
  }
}
require("neogit").setup {}
