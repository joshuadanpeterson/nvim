-- Detect Strudel filetypes by extension, ensuring .str* open as 'strudel'
vim.filetype.add({
  extension = {
    strudel = 'strudel',
    strdl = 'strudel',
    str = 'strudel',
    std = 'strudel',
  },
})

-- Fallback override in case another plugin assigns javascript
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { '*.str', '*.strdl', '*.strudel', '*.std' },
  callback = function()
    vim.bo.filetype = 'strudel'
  end,
})

-- If something later forces javascript, re-map matching buffers back to strudel
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'javascript', 'javascriptreact' },
  callback = function()
    local name = vim.api.nvim_buf_get_name(0)
    if name:match('%.str$') or name:match('%.strdl$') or name:match('%.strudel$') or name:match('%.std$') then
      vim.schedule(function()
        vim.bo.filetype = 'strudel'
      end)
    end
  end,
})
