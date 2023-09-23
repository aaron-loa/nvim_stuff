local ls = require("luasnip")
local snip = ls.snippet
local node = ls.snippet_node
local text = ls.text_node
local insert = ls.insert_node
local func = ls.function_node
local choice = ls.choice_node
local dynamicn = ls.dynamic_node
local counter = 0

local function get_variable_name_on_cursor()
	local bufnr = vim.api.nvim_get_current_buf()
  local current_position = vim.api.nvim_win_get_cursor(0)
  -- if current_node ~= nil then
  --   local string = vim.treesitter.get_node_text(current_node, bufnr)
  --   return string 
  -- end
  counter = counter + 1
  return current_position[1].. " "..current_position[2]
end

ls.add_snippets(nil, {
  php = {
    snip({
        trig = "comment",
        namr = "Php comment",
        dscr = "Php annotation commnet"
      },
      {
        -- text({ "/** @var type_here $var_name */" }),
        func(get_variable_name_on_cursor, {}),
      }
    )
  }
})
