# rex-navigator.nvim

Move between Neovim splits and Rex panes with `<C-h>`, `<C-j>`, `<C-k>`, and `<C-l>`.

Neovim handles the move when another window sits in that direction. At the edge of the current tab, the same key asks Rex to focus the neighboring pane (`rex focus left|down|up|right` in `$REX_SESSION`). A companion module binds the same keys inside Rex so focus can return to Neovim.

## Install

### lazy.nvim

```lua
{
  'sergejgavrilov/rex-navigator.nvim',
  config = function()
    require('rex-navigator').setup()
  end,
}
```

### vim.pack

```lua
vim.pack.add({ 'https://github.com/sergejgavrilov/rex-navigator.nvim' })
require('rex-navigator').setup()
```

### Rex

Copy or symlink `rex/navigator.lua` where your Rex config can `require` it, then call it from `~/.config/rex/init.lua`:

```lua
package.path = package.path .. ';/path/to/rex-navigator.nvim/?.lua'
require('rex.navigator').setup()
```

`rex.bind` registers `ctrl+h/j/k/l` as `pane.focus`. Reload with `rex config reload`.

## Keybindings

| Key | Direction |
| --- | --- |
| `<C-h>` | left |
| `<C-j>` | down |
| `<C-k>` | up |
| `<C-l>` | right |

Mappings are set in normal, visual, and terminal mode.

## Configuration

```lua
require('rex-navigator').setup({
  -- Skip the Rex handoff while the current block is zoomed.
  disable_when_zoomed = false,
  keymaps = {
    left = '<C-h>',
    down = '<C-j>',
    up = '<C-k>',
    right = '<C-l>',
  },
})
```

Set `keymaps = false` to skip default mappings and call `require('rex-navigator').navigate('h'|'j'|'k'|'l')` yourself.

On the Rex side, pass a `keys` table to replace the defaults:

```lua
require('rex.navigator').setup({
  keys = { h = 'left', j = 'down', k = 'up', l = 'right' },
})
```

## License

MIT
