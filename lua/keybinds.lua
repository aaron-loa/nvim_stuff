vim.g.mapleader = " "

vim.keymap.set("n", "<", "<<", { silent = true })
vim.keymap.set("n", "<C-d>", "<C-d>zz <CR>", { silent = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz <CR>", { silent = true })
vim.keymap.set("n", "<F3>", ":Telescope aerial <CR>")
vim.keymap.set("n", "<F5>", vim.cmd.UndotreeToggle)
vim.keymap.set("n", "<S-Tab>", ":bp<CR>", { silent = true })
vim.keymap.set("n", "<c-i>", ":bn<CR>", { silent = true })
vim.keymap.set("n", "<leader>R", [[:lua require("memento").toggle()<CR>]])
vim.keymap.set("n", "<leader>cc", ":Telescope neoclip default<CR>", { silent = true })
vim.keymap.set("n", "<leader>e", ":NvimTreeFocus<CR>", { silent = true })
vim.keymap.set("n", "<leader>fa", ":NeoformatExtra<CR>") -- custom command
vim.keymap.set("n", "<leader>fq", ":SortDeclarations<CR>", { silent = true }) -- custom command
vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>")
vim.keymap.set("n", "<leader>le", vim.diagnostic.goto_next, { buffer = vim.api.nvim_get_current_buf() })
vim.keymap.set("n", "<leader>lw", vim.diagnostic.goto_prev, { buffer = vim.api.nvim_get_current_buf() })
vim.keymap.set("n", "<leader>pV", ":Telescope projects<CR>", { silent = true })
vim.keymap.set("n", "<leader>pv", ":ProjectView <CR>", { silent = true }) -- custom command
vim.keymap.set("n", "<leader>r", ":NvimTreeFindFile<CR>", { silent = true })
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>tp", [[:TroubleToggle telescope <CR>]], { silent = true })
vim.keymap.set("n", "<leader>tq", [[:TroubleToggle quickfix <CR>]], { silent = true })
vim.keymap.set("n", "<leader>tt", [[:TroubleToggle workspace_diagnostics <CR>]], { silent = true })
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
vim.keymap.set("n", ">", ">>", { silent = true })
vim.keymap.set("n", "x", [[v"_d]]) -- remove single character and put it in void register
vim.keymap.set("n", "zz", "zz zH") -- center cursor

vim.keymap.set("v", "<F12>", ":SnipRun <CR>") -- run selection
vim.keymap.set("v", "<c-j>", ":m '>+1<CR>gv=gv") -- move selection one line up
vim.keymap.set("v", "<c-k>", ":m '<-2<CR>gv=gv") -- down
vim.keymap.set("v", "J","j") -- can hold shift while in v mode
vim.keymap.set("v", "K", "k")

vim.keymap.set("x", "<leader>p", [["_dP]])

