-- require("plenary.reload").reload_module("preload-google-fonts")

local M = {}
-- valid font format strings
-- http://www.iana.org/assignments/media-types/media-types.xhtml#font
-- collection 	font/collection 	[RFC8081]
-- otf 	font/otf 	[RFC8081]
-- sfnt 	font/sfnt 	[RFC8081]
-- ttf 	font/ttf 	[RFC8081]
-- woff 	font/woff 	[RFC8081]
-- woff2 	font/woff2 	[RFC8081]

M.html_pattern = [[
  {# !comment #}
  <link rel="preload" href="!url" as="font" type="font/!format" crossorigin>
]]

local print = function(x)
  if type(x) == "table" then
    vim.print((vim.inspect(x)))
  else
    vim.print(x)
  end
end

local curl = require('plenary.curl')

M.clean_string = function(str)
  str = string.gsub(str, [["]], "")
  str = string.gsub(str, [[']], "")
  str = string.gsub(str, [[-]], "_")
  return str
end

M.setup = function()
  vim.api.nvim_create_user_command("PreloadGoogleFonts", function(opts)
    local url = opts.args
    M.procedure(url)
  end, {
    nargs = 1,
    bang = true,
    desc = "PreloadGoogleFonts",
  })
end

M.make_request = function(gfonts_url)
  local response = curl.get(gfonts_url, {
    -- google fonts sends wrong ttf instead of woff2 if you are not a browser
    raw = { "-A", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3" },
  }
  )
  return response.body
end

M.parse = function(bufnr)
  local query = M.query()
  local parser = vim.treesitter.get_parser(bufnr, "scss", {})
  local tree = parser:parse()[1]
  local root = tree:root()
  local all_matches = {}

  for pattern, match, metadata in query:iter_matches(root, bufnr, 0, -1) do
    local current_match = {}
    for id, node in ipairs(match) do
      local capture_name = query.captures[id]
      --- @type TSNode
      node = node
      capture_name = M.clean_string(capture_name)
      local text_value = vim.treesitter.get_node_text(node, bufnr)
      text_value = M.clean_string(text_value)
      current_match[capture_name] = text_value
    end
    -- techinically the query should guarantee these i think
    assert(current_match.url, "No url found")
    assert(current_match.format, "No format found")
    assert(current_match.font_weight, "No font weight found")
    assert(current_match.font_family, "No font family found")
    all_matches[#all_matches + 1] = current_match
  end
  vim.print(all_matches)
  return all_matches
end

M.get_html = function(url, format, font_name, weight)
  local formatted = string.gsub(M.html_pattern, "!url", url)
  if format == "truetype" then
    format = "ttf"
  end
  formatted = string.gsub(formatted, "!format", format)
  local comment = string.format(" %s %s ", font_name, weight)
  formatted = string.gsub(formatted, "!comment", comment)
  return formatted
end

M.procedure = function(url)
  local response = M.make_request(url)

  if response == nil then
    vim.notify("No response from server")
    return
  end

  local temp_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(temp_buf, -1, -1, false, vim.split(response, "\n"))
  vim.bo[temp_buf].filetype = "scss"
  -- vim.api.nvim_open_win(temp_buf, true, {
  --   split = "right",
  -- })
  local parsed_info = M.parse(temp_buf)
  vim.api.nvim_buf_set_lines(0, -1, -1, false, { "/*" })
  for i, match in pairs(parsed_info) do
    local html = M.get_html(match.url, match.format, match.font_family, match.font_weight)
    vim.api.nvim_buf_set_lines(0, -1, -1, false, vim.split(html, "\n"))
  end
  vim.api.nvim_buf_set_lines(0, -1, -1, false, { "*/" })
  vim.api.nvim_buf_set_lines(0, -1, -1, false, vim.split(response, "\n"))
end

M.query = function()
  return vim.treesitter.query.parse(
    "scss",
    [[
(
  at_rule
  (#eq? at_keyword "font-face")
  (block
    (declaration
      (
       (property_name) @font-family-property
       [
         (string_value)
         (plain_value)
        ] @font_family
      )(#eq? @font-family-property "font-family")
    )
    (declaration
      (
       (property_name) @font-weight-property
       (integer_value) @font-weight
      )(#eq? @font-weight-property "font-weight")
    )
    (declaration
      (#eq? property_name "src")
      (call_expression
        (#eq? function_name "url")
        (arguments
          (plain_value) @url
        )
      )
      (call_expression
        (#eq? function_name "format")
        (arguments
          (string_value) @format
        )
      )
    )
  )
)
    ]]
  )
end

return M
