# rex-navigator.nvim

`<C-h/j/k/l>` moves between Neovim windows. At the edge it focuses the neighboring Rex pane, then the previous or next Rex window when no pane is there. `<C-h>` and `<C-k>` move to the previous window. `<C-l>` and `<C-j>` move to the next one.

## Install

lazy.nvim:

```lua
{ 'Kopfdreher/rex-navigator.nvim', opts = {} }
```

vim.pack:

```lua
vim.pack.add({ 'https://github.com/Kopfdreher/rex-navigator.nvim' })
require('rex-navigator').setup()
```

Rex, in `~/.config/rex/init.lua`:

```lua
package.path = package.path .. ';/path/to/rex-navigator.nvim/?.lua'
require('rex.navigator').setup()
```

Then `rex config reload`. This binds `ctrl+h/j/k/l` to `pane.focus`.

## Keys

| Key | Direction |
| --- | --- |
| `<C-h>` | left |
| `<C-j>` | down |
| `<C-k>` | up |
| `<C-l>` | right |

Normal, visual, and terminal mode.

## Options

```lua
require('rex-navigator').setup({
  disable_when_zoomed = false, -- do not hand off while the Rex block is zoomed
  keymaps = { -- false to set none
    left = '<C-h>',
    down = '<C-j>',
    up = '<C-k>',
    right = '<C-l>',
  },
})
```

Call `require('rex-navigator').navigate('h'|'j'|'k'|'l')` for your own mappings.

Rex keys:

```lua
require('rex.navigator').setup({
  keys = { h = 'left', j = 'down', k = 'up', l = 'right' },
})
```

MIT
