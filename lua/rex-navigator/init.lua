local M = {}

local defaults = {
  disable_when_zoomed = false,
  keymaps = {
    left = '<C-h>',
    down = '<C-j>',
    up = '<C-k>',
    right = '<C-l>',
  },
}

local to_rex = { h = 'left', j = 'down', k = 'up', l = 'right' }
local to_wincmd = { left = 'h', down = 'j', up = 'k', right = 'l' }

local function blank(value)
  return value == nil or value == ''
end

local function rex(args)
  return vim.system({ 'rex', unpack(args) }, { text = true }):wait()
end

local function zoomed(session)
  if not M.options.disable_when_zoomed or blank(vim.env.REX_BLOCK) then
    return false
  end
  local result = rex({ 'block', 'inspect', vim.env.REX_BLOCK, '-s', session, '--json' })
  return result.code == 0
    and result.stdout ~= nil
    and result.stdout:find('"zoomed"%s*:%s*true') ~= nil
end

local function active_block(session)
  local result = rex({ 'session', 'inspect', session, '--json' })
  if result.code ~= 0 or blank(result.stdout) then
    return nil
  end
  local ok, data = pcall(vim.json.decode, result.stdout)
  if not ok or type(data) ~= 'table' or type(data.windows) ~= 'table' then
    return nil
  end
  for _, window in ipairs(data.windows) do
    if window.window_id == data.active_window_id then
      return window.focused_block_id
    end
  end
end

function M.navigate(dir)
  local win = vim.api.nvim_get_current_win()
  vim.cmd.wincmd(dir)
  if vim.api.nvim_get_current_win() ~= win then
    return
  end
  local session = vim.env.REX_SESSION
  local direction = to_rex[dir]
  if blank(session) or not direction or zoomed(session) then
    return
  end
  local before = active_block(session) or vim.env.REX_BLOCK
  rex({ 'focus', direction, '-s', session })
  if active_block(session) ~= before then
    return
  end
  local step = (dir == 'h' or dir == 'k') and 'prev' or 'next'
  rex({ 'window', 'focus', step, '--wrap', '-s', session })
end

function M.setup(opts)
  M.options = vim.tbl_deep_extend('force', {}, defaults, opts or {})
  local keymaps = M.options.keymaps
  if not keymaps then
    return
  end
  for name, lhs in pairs(keymaps) do
    local dir = to_wincmd[name]
    if dir and lhs and lhs ~= '' then
      vim.keymap.set({ 'n', 'x', 't' }, lhs, function()
        M.navigate(dir)
      end, { desc = 'Navigate ' .. name, silent = true })
    end
  end
end

M.options = vim.deepcopy(defaults)

return M
