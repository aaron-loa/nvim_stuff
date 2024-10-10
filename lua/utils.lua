local M = {}

function M.CustomGoToDefinition()
  local coord = vim.api.nvim_win_get_cursor(0)
  local lsp_response = vim.lsp.buf_request_sync(0, "textDocument/definition", {
      textDocument = vim.lsp.util.make_text_document_params(),
      position = { line = coord[1] - 1, character = coord[2] }
    })
  if lsp_response == nil then
    vim.print("null response from LSP??")
    return
  end
  -- vim.print(vim.inspect(lsp_response))
  for _, x in pairs(lsp_response) do
    local result = x.result

    if result ~= nil and result[1] ~= nil then
      result = x.result[1]
    end
    if result ~= nil and
      (result.targetUri ~= nil or
          result.uri ~= nil) then
      local real_uri = nil
      -- uri can be in either targetUri or uri
      if result.targetUri ~= nil then
        real_uri = result.targetUri
      end

      if result.uri ~= nil then
        real_uri = result.uri
      end

      if result.uri ~= nil then
        real_uri = result.uri
      end

      if real_uri == nil then
        return
      end

      local path_of_definition = vim.uri_to_fname(real_uri)
      local current_buffer_path = vim.api.nvim_buf_get_name(0)
      if path_of_definition ~= current_buffer_path then
        -- TODO possibly only do this if file is in gitignore? needs testing
        require('goto-preview').goto_preview_definition()
        return
      else
        vim.lsp.buf.definition({})
        return
      end
      break
    end
  end
end

local git_error = "fatal: not a git repository (or any of the parent directories): .git"

function M.git_path()
  local git_output = vim.fn.systemlist('git rev-parse --show-toplevel')

  if type(git_output[1]) ~= 'string' then
    return nil
  end
  local git_path = git_output[1]
  if git_path == git_error then
    return nil
  else
    return git_path
  end
end


function M.get_nvim_tree_node_path()
  return require("nvim-tree.lib").get_node_at_cursor().absolute_path or nil
end

return M
