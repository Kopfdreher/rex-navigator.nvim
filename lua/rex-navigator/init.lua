local config = require('rex-navigator.config')

local M = {}

local directions = {
  h = 'left',
  j = 'down',
  k = 'up',
  l = 'right',
}

local function zoomed()
  if not config.options.disable_when_zoomed then
    return false
  end
  local block = vim.env.REX_BLOCK
  local session = vim.env.REX_SESSION
  if not block or block == '' or not session or session == '' then
    return false
  end
  local result = vim.system({
    'rex',
    'block',
    'inspect',
    block,
    '-s',
    session,
    '--json',
  }, { text = true }):wait()
  if result.code ~= 0 or not result.stdout then
    return false
  end
  return result.stdout:match('"zoomed"%s*:%s*true') ~= nil
end

local function focus_rex(dir)
  local session = vim.env.REX_SESSION
  if not session or session == '' or zoomed() then
    return
  end
  local direction = directions[dir]
  if not direction then
    return
  end
  vim.system({ 'rex', 'focus', direction, '-s', session }, { text = true }):wait()
end

function M.navigate(dir)
  local before = vim.api.nvim_get_current_win()
  vim.cmd('wincmd ' .. dir)
  if vim.api.nvim_get_current_win() == before then
    focus_rex(dir)
  end
end

local keymap_for = {
  left = 'h',
  down = 'j',
  up = 'k',
  right = 'l',
}

local function apply_keymaps()
  local keymaps = config.options.keymaps
  if keymaps == false then
    return
  end
  for name, dir in pairs(keymap_for) do
    local lhs = keymaps[name]
    if lhs and lhs ~= '' then
      vim.keymap.set({ 'n', 'x', 't' }, lhs, function()
        M.navigate(dir)
      end, { desc = 'Rex navigator ' .. name, silent = true })
    end
  end
end

function M.setup(opts)
  config.setup(opts)
  apply_keymaps()
end

return M
