-- [nfnl] fnl/setup/util.fnl
local util = {}
util["ensure-plugin"] = function(plugin, _3fconfig)
  _G.assert((nil ~= plugin), "Missing argument plugin on /var/home/david/Worktrees/setup.nvim/fnl/setup/util.fnl:3")
  local config = (_3fconfig or {})
  local module = ("setup.registry." .. plugin)
  local spec
  do
    local _1_, _2_ = pcall(require, module)
    if ((_1_ == true) and (nil ~= _2_)) then
      local s = _2_
      spec = s
    elseif (nil ~= _1_) then
      local rest = _1_
      local parts = vim.split(plugin, ".", {plain = true, trimempty = true})
      local _3_ = #parts
      if (_3_ == 1) then
        spec = error(("module not in registry: " .. plugin))
      elseif (nil ~= _3_) then
        local l = _3_
        spec = util["ensure-plugin"](vim.iter({unpack(parts, 1, (l - 1))}):join("."))
      else
        spec = nil
      end
    else
      spec = nil
    end
  end
  for _, dep in ipairs((spec.dependencies or {})) do
    util["ensure-plugin"](dep)
  end
  vim.pack.add({spec.pack})
  return spec
end
util["keymap-handler"] = function(_6_)
  local _3fconfig = _6_["keymap"]
  local config
  do
    local _7_ = type(_3fconfig)
    if (_7_ == "function") then
      config = _3fconfig()
    else
      local _ = _7_
      config = _3fconfig
    end
  end
  if config then
    for key, val in pairs(config) do
      if ((_G.type(val) == "table") and (nil ~= val.cmd) and (nil ~= val.mode)) then
        local cmd = val.cmd
        local mode = val.mode
        vim.keymap.set(mode, key, cmd)
      elseif (nil ~= val) then
        local cmd = val
        vim.keymap.set("n", key, cmd)
      else
      end
    end
    return nil
  else
    return nil
  end
end
return util
