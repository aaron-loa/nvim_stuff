vim.g.mapleader = " "

local function CustomGoToDefinition()
  local coord = vim.api.nvim_win_get_cursor(0)
  local lsp_response = vim.lsp.buf_request_sync(0, "textDocument/definition", {
      textDocument = vim.lsp.util.make_text_document_params(),
      position = { line = coord[1] - 1, character = coord[2] }
    },
    500)
  if lsp_response == nil then
    return
  end

  for i, x in pairs(lsp_response) do
    if x.result ~= nil and
        x.result[1] ~= nil and
        x.result[1].targetUri ~= nil then
      local path_of_definition = vim.uri_to_fname(x.result[1].targetUri)
      local current_buffer_path = vim.api.nvim_buf_get_name(0)
      if path_of_definition ~= current_buffer_path then
        -- TODO possibly only do this if file is in gitignore? needs testing
        require('goto-preview').goto_preview_definition({})
      else
        vim.lsp.buf.definition({})
      end
      break
    end
  end
end

vim.keymap.set("n", "<", "<<", { silent = true })
vim.keymap.set("n", "<C-d>", "<C-d>zz <CR>", { silent = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz <CR>", { silent = true })
vim.keymap.set("n", "<leader>ft", ":Telescope aerial <CR>", { silent = true })
vim.keymap.set("n", "<F5>", vim.cmd.UndotreeToggle)
vim.keymap.set("n", "gd", CustomGoToDefinition)
vim.keymap.set("n", "<S-Tab>", ":b#<CR>", { silent = true })
vim.keymap.set("n", "<leader>R", [[:lua require("memento").toggle()<CR>]], { silent = true })
vim.keymap.set("n", "<leader>cc", ":Telescope neoclip default<CR>", { silent = true })
vim.keymap.set("n", "<leader>e", ":NvimTreeFocus<CR>", { silent = true })
vim.keymap.set("n", "<leader>fa", vim.lsp.buf.format)
vim.keymap.set("n", "<leader>fq", ":SortDeclarations<CR>", { silent = true }) -- custom command
vim.keymap.set("n", "<leader>gg", ":Neogit<CR>")
vim.keymap.set("n", "<leader>le", vim.diagnostic.goto_next, { buffer = vim.api.nvim_get_current_buf() })
vim.keymap.set("n", "<leader>lw", vim.diagnostic.goto_prev, { buffer = vim.api.nvim_get_current_buf() })
vim.keymap.set("n", "<leader>pV", ":Telescope projects<CR>", { silent = true })
vim.keymap.set("n", "<leader>pv", ":ProjectView <CR>", { silent = true })      -- custom command
vim.keymap.set("n", "<leader>fp", ":Telescope resume <CR>", { silent = true }) -- custom command
vim.keymap.set("n", "<leader>r", ":NvimTreeFindFile<CR>", { silent = true })
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>tp", [[:TroubleToggle telescope <CR>]], { silent = true })
vim.keymap.set("n", "<leader>tq", [[:TroubleToggle quickfix <CR>]], { silent = true })
vim.keymap.set("n", "<leader>tt", [[:TroubleToggle workspace_diagnostics <CR>]], { silent = true })
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
vim.keymap.set("n", "<leader>dr", ":lua require('builder').setup()<CR>", { silent = true })
vim.keymap.set("n", ">", ">>", { silent = true })
vim.keymap.set("n", "x", [[v"_d]]) -- remove single character and put it in void register
vim.keymap.set("n", "zz", "zz zH") -- center cursor
vim.keymap.set("n", "ZZ", ":qa!<CR>")

vim.keymap.set("n", "mg", "`")                   -- reasonable marks

vim.keymap.set("v", "<c-j>", ":m '>+1<CR>gv=gv") -- move selection one line up
vim.keymap.set("v", "<c-k>", ":m '<-2<CR>gv=gv") -- down
vim.keymap.set("v", "J", "j")                    -- can hold shift while in v mode
vim.keymap.set("v", "K", "k")                    -- can hold shift while in v mode

vim.keymap.set("n", "<F8>", ":lua require('dapui').toggle()<CR>")
vim.keymap.set("n", "<F9>", ":DapToggleBreakpoint<CR>")

vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set("x", "<leader>p", [["_dP]])

local ls = require("luasnip")
vim.keymap.set({ "i" }, "<C-K>", function() ls.expand() end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-L>", function() ls.jump(1) end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-H>", function() ls.jump(-1) end, { silent = true })

vim.keymap.set("i", "<C-j>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end, { silent = true })

-- vim.api.nvim_set_keymap('i', '<C-8>', [[<C-O>:lua require('copilot').complete_comment()<CR>]], { noremap = true, silent = true })
-- :copilot#Accept('
-- ')
--
vim.cmd([[imap <silent><script><expr> <C-Space> copilot#Accept("\<CR>")]])
vim.keymap.set("i", "<C-j>", "copilot#Next()", { expr = true, silent = true })
vim.keymap.set("i", "<C-k>", "copilot#Previous()", { expr = true, silent = true })
vim.keymap.set("i", "<C-x>", "copilot#Dismiss()", { expr = true, silent = true })
vim.keymap.set("i", "<C-s>", "copilot#Suggest()", { expr = true, silent = true })
vim.keymap.set("i", "<F10>", "copilot#Comment()", { expr = true, silent = true })

-- file
--
