local M = {}

M.defaults = {
  disable_when_zoomed = false,
  keymaps = {
    left = '<C-h>',
    down = '<C-j>',
    up = '<C-k>',
    right = '<C-l>',
  },
}

M.options = {}

function M.setup(opts)
  M.options = vim.tbl_deep_extend('force', {}, M.defaults, opts or {})
end

return M
