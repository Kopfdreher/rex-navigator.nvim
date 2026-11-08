local default_keys = {
  h = 'left',
  j = 'down',
  k = 'up',
  l = 'right',
}

return {
  setup = function(opts)
    for key, dir in pairs((opts and opts.keys) or default_keys) do
      rex.bind('ctrl+' .. key, 'pane.focus', { direction = dir })
    end
  end,
}
