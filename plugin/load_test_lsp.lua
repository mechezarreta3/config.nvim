---@diagnostic disable-next-line: missing-fields
local client = vim.lsp.start_client {
  name = "educationalsp",
  cmd = { "/home/wellackshually/lsp/educationalsp/main" }
}

if not client then
  vim.notify("Hey, you didn't do the client thing good")
  return
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.lsp.buf_attach_client(0, client)
  end,
})
