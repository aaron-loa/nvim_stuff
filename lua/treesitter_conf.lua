require("nvim-treesitter.configs").setup({
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
    disable = function(lang, bufnr) -- Disable in large C++ buffers
      -- return lang == "cpp" and vim.api.nvim_buf_line_count(bufnr) > 50000
      return vim.api.nvim_buf_line_count(bufnr) > 3000 or vim.api.nvim_buf_line_count(bufnr) == 1
      -- return vim.fn.winwidth(bufnr) > 100000
    end,
  },
  -- playground = {
  --   enable = true,
  --   disable = {},
  --   updatetime = 25,         -- Debounced time for highlighting nodes in the playground from source code
  --   persist_queries = true, -- Whether the query persists across vim sessions
  --   keybindings = {
  --     toggle_query_editor = "o",
  --     toggle_hl_groups = "i",
  --     toggle_injected_languages = "t",
  --     toggle_anonymous_nodes = "a",
  --     toggle_language_display = "I",
  --     focus_language = "f",
  --     unfocus_language = "F",
  --     update = "R",
  --     goto_node = "<cr>",
  --     show_help = "?",
  --   },
  -- },
})
require("nvim-treesitter.query")

-- local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
-- parser_config.custom_scss = {
--   install_info = {
--     url = "/home/ron/programs/tree-sitter-scss", -- local path or git repo
--     files = {"src/parser.c", "src/scanner.c"}, -- note that some parsers also require src/scanner.c or src/scanner.cc
--     -- optional entries:
--     -- branch = "main", -- default branch in case of git repo if different from master
--     generate_requires_npm = true, -- if stand-alone parser without npm dependencies
--     requires_generate_from_grammar = true, -- if folder contains pre-generated src/parser.c
--     filetype = "scss", -- if filetype does not agrees with parser name
--   },
-- }
