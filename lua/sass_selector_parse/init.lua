local M = {}
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values

M.telescope_inegration = function()
  pickers
      .new({}, {
        prompt_title = "Git Files",
        finder = finders.new_table {
          results = M.parse(),
          entry_maker = function(entry)
            return {
              value = entry.selector,
              display = entry.selector,
              ordinal = entry.selector,
              path = vim.api.nvim_buf_get_name(0),
              lnum = entry.coords + 1,
            }
          end,
        },
        previewer = conf.qflist_previewer({}),
        sorter = conf.generic_sorter(),
      })
      :find()
end

---@return table
M.parse = function()
  local bufnr = vim.api.nvim_get_current_buf()
  if vim.bo[bufnr].filetype ~= "scss" then
    return {}
  end
  local query = M.query()
  local parser = vim.treesitter.get_parser(bufnr, "scss", {})
  local tree = parser:parse()[1]
  local root = tree:root()
  local matches = {}
  for _, node in query:iter_captures(root, bufnr, 0, -1) do
    local selector = M.parse_rule_set(node)
    if selector == "" then
      goto continue
    end
    -- maybe better if
    -- .foo,
    -- .bar {
    -- }
    -- becomes .foo AND .bar seperated from each other
    selector = selector:gsub("\n", " ")
    selector = selector:gsub(" &", "")
    local object = {
      selector = selector,
      coords = vim.treesitter.get_node_range(node)
    }
    matches[#matches + 1] = object
    ::continue::
  end
  return matches
end

---@param node TSNode
---@return string
M.parse_rule_set = function(node)
  local name = M.parse_selector_in_rule_set(node)
  local parent = node:parent()
  if parent == nil then
    return name
  end
  while parent do
    if parent:type() == "rule_set" then
      name = M.parse_selector_in_rule_set(parent) .. " " .. name
    end
    parent = parent:parent()
  end
  return name
end


---@param node TSNode
---@return string
-- can return empty string
M.parse_selector_in_rule_set = function(node)
  for child in node:iter_children() do
    if child:type() == "selectors" then
      return vim.treesitter.get_node_text(child, vim.api.nvim_get_current_buf())
    end
  end
  return ""
end

M.query = function()
  return vim.treesitter.query.parse(
    "scss",
    [[
    (rule_set) @rules
    ]]
  )
end

return M
