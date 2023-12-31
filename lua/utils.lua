local M = {}

function M.CustomGoToDefinition()
  vim.print("hello")
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

return M
