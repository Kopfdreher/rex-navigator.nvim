local M = {}

function M.setup(opts)
  opts = opts or {}
  local keys = opts.keys or {
    h = "left",
    j = "down",
    k = "up",
    l = "right",
  }

  for key, dir in pairs(keys) do
    rex.bind("ctrl+" .. key, "pane.focus", { direction = dir })
  end
end

return M
