local ls = require("luasnip")
local snip = ls.snippet
local node = ls.snippet_node
local t = ls.text_node
local insert = ls.insert_node
local func = ls.function_node
local choice = ls.choice_node
local dynamic = ls.dynamic_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

local function find_last_occurrence(str, char)
  local last_index = nil
  for i = 1, #str do
    if str:sub(i, i) == char then
      last_index = i
    end
  end
  return last_index
end

--- walk_back directories
---@param path string
local function walk_back(path)
  local last_index = find_last_occurrence(path, "/")
  return path:sub(0, last_index - 1)
end

--- unused but very cool
---@param path string
local function parse_yml(path)
  local created_buffer = vim.api.nvim_create_buf(true, true)
  local contents = {}
  for line in io.lines(path) do
    table.insert(contents, line)
  end
  vim.api.nvim_buf_set_lines(created_buffer, 0, #contents, false, contents)
  vim.api.nvim_set_current_buf(created_buffer)
  local parser = vim.treesitter.get_parser(created_buffer, "yaml")
  local tree = parser:parse()[1]:root()
  local declarations = vim.treesitter.query.parse(
    "yaml",
    [[
    (block_mapping_pair
    key: (flow_node) @key
    value: (flow_node) @value
    )
    ]]
  )
  for _, node in declarations:iter_captures(tree, created_buffer, 0, -1) do
    local value = vim.treesitter.get_node_text(node, created_buffer)
    vim.print(value)
  end
end

local function get_current_module_name()
  local uv = vim.uv
  local root_path = vim.fn.getcwd()
  local current_dir = vim.api.nvim_buf_get_name(0)
  local path_of_info_yml = ""
  while current_dir ~= root_path do
    current_dir = walk_back(current_dir)
    local dir = uv.fs_scandir(current_dir)
    if dir and path_of_info_yml == "" then
      while true do
        local name, type = uv.fs_scandir_next(dir)
        if not name then
          break
        end
        if type == "file" then
          if name:find("info.yml") then
            path_of_info_yml = name
            break
          end
        end
      end
    else
      break
    end
  end
  if path_of_info_yml ~= "" then
    local first_index = string.find(path_of_info_yml, "%.")
    return path_of_info_yml:sub(0, first_index - 1)
  end
  return "cant_find_module_name"
end
ls.add_snippets(nil, {
  php = {
    snip({
        trig = "module",
        namr = "current module",
        dscr = "returns current module machine name"
      },
      {
        func(get_current_module_name, {}),
      }
    )
  },
})
ls.add_snippets(nil, {
  all = {
    snip("dru_log",
      fmt([[\Drupal::logger('{}')->{}({})]],
        { func(get_current_module_name, {}), choice(1, { t("info"), t("warn") }), i(2) })
    -- \Drupal::logger('migrate_ma7')->info($node->id() . ' tartalomban a beágyazott videó lecserélve médiára.');
    )
  }
})
-- ls.config.set_config( {
--
--   history = true,
--   updateevents = "TextChanges,TextChangedI",
--   enable_autosnippets = true,
-- })
-- function ()
--
-- end
