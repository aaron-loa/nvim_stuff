vim.api.nvim_create_user_command("NeoformatExtra", function()
	local bufnr = vim.api.nvim_get_current_buf()
	if vim.bo[bufnr].filetype == "scss" then
		vim.cmd({ cmd = "Neoformat" })
		vim.api.nvim_command(vim.api.nvim_exec(":%s/\\W0\\./ ./g", true))
	else
		vim.cmd({ cmd = "Neoformat" })
	end
end, {})

vim.api.nvim_create_user_command("W", function()
	vim.cmd([[write]])
end, {})

vim.api.nvim_create_user_command("SortDeclarations", function()
	local bufnr = vim.api.nvim_get_current_buf()
	if vim.bo[bufnr].filetype ~= "scss" then
		print("Not scss file")
		return
	end
	local get_root = function(bufnumber)
		local parser = vim.treesitter.get_parser(bufnumber, "scss", {})
		local tree = parser:parse()[1]
		return tree:root()
	end
	local root = get_root(bufnr)
	local declarations = vim.treesitter.parse_query(
		"scss",
		[[
    (declaration
    ) @dec
    ]]
	)
	local css_order = require("css_order").errex_order()
	local css_decs = {}
	local tmp = { entries = {} }
	for _, node in declarations:iter_captures(root, bufnr, 0, -1) do
		local row1, col1, row2 = node:range()
		local text = vim.treesitter.get_node_text(node, bufnr)
		local entry = {}
		entry["text"] = text
		entry["row1"] = row1
		entry["row2"] = row2
		entry["col1"] = col1

		for k in string.gmatch(text, "([^:]+)") do
			entry["declaration"] = k
			break
		end

		if not next(tmp.entries) or entry["row1"] == tmp.entries[#tmp.entries]["row2"] + 1 then
			table.insert(tmp.entries, entry)
		else
			table.insert(css_decs, tmp)
			tmp = { entries = {} }
			table.insert(tmp.entries, entry)
		end
	end

	if next(tmp.entries) then
		table.insert(css_decs, tmp)
	end

	for _, v in pairs(css_decs) do
		v["start"] = v.entries[1].row1
		v["end"] = v.entries[#v.entries].row2
		table.sort(v.entries, function(val1, val2)
			return (css_order[val1.declaration] or 0) < (css_order[val2.declaration] or 0)
		end)
		local change = {}
		for _, v1 in pairs(v.entries) do
			for k in string.gmatch(v1["text"], "([^\n]+)") do
				if string.match(k, "^%W") then
					table.insert(change, k)
				else
					table.insert(change, string.rep(" ", v1["col1"]) .. k)
				end
			end
			-- table.insert(change, 1, string.rep(" ", v1["col1"]) .. v1["text"])
		end
		vim.api.nvim_buf_set_lines(bufnr, v["start"], v["end"] + 1, false, change)
	end
end, {})

local function split(str, sep)
	local result = {}
	local regex = ("([^%s]+)"):format(sep)
	for each in str:gmatch(regex) do
		table.insert(result, each)
	end
	return result
end

local data = vim.api.nvim_command_output(":!pv_list")
data = vim.split(data, "\n")

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local paths = function(opts)
	opts = opts or {}
	pickers
		.new(opts, {
			prompt_title = "colors",
			finder = finders.new_table({
				results = { unpack(data , 4, #data ) },
			}),
			sorter = conf.generic_sorter(opts),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
	        local bufnr = vim.api.nvim_get_current_buf()
					local selection = action_state.get_selected_entry()
					vim.api.nvim_exec(string.format(":terminal nohup alacritty --command nvim %s >> /dev/null", selection[1]), true)
					vim.api.nvim_set_current_buf(bufnr)
				end)
				return true
			end,
		})
		:find()
end

vim.api.nvim_create_user_command("ProjectView", function()
	paths()
end, {})
