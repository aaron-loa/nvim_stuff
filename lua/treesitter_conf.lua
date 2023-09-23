if vim.g.vscode == nil then
  require("nvim-treesitter.configs").setup({
    sync_insall = false,
    auto_install = true,
    highlight = {
      enable = true,
      disable = function(lang, bufnr) -- Disable in large C++ buffers
        -- return lang == "cpp" and vim.api.nvim_buf_line_count(bufnr) > 50000
        return vim.api.nvim_buf_line_count(bufnr) > 10000 or vim.api.nvim_buf_line_count(bufnr) == 1
        -- return vim.fn.winwidth(bufnr) > 100000
      end,
    },
    playground = {
      enable = true,
      disable = {},
      updatetime = 25,      -- Debounced time for highlighting nodes in the playground from source code
      persist_queries = false, -- Whether the query persists across vim sessions
      keybindings = {
        toggle_query_editor = "o",
        toggle_hl_groups = "i",
        toggle_injected_languages = "t",
        toggle_anonymous_nodes = "a",
        toggle_language_display = "I",
        focus_language = "f",
        unfocus_language = "F",
        update = "R",
        goto_node = "<cr>",
        show_help = "?",
      },
    },
  })
end
