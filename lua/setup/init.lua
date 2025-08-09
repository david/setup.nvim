-- [nfnl] fnl/setup/init.fnl
local function ensure_plugin(plugin, _3fconfig)
  _G.assert((nil ~= plugin), "Missing argument plugin on /var/home/david/Worktrees/setup.nvim/fnl/setup/init.fnl:1")
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
        spec = ensure_plugin(vim.iter({unpack(parts, 1, (l - 1))}):join("."))
      else
        spec = nil
      end
    else
      spec = nil
    end
  end
  for _, dep in ipairs((spec.dependencies or {})) do
    ensure_plugin(dep)
  end
  vim.pack.add({spec.pack})
  return spec
end
local handlers = {}
local function define_handler_group(name)
  _G.assert((nil ~= name), "Missing argument name on /var/home/david/Worktrees/setup.nvim/fnl/setup/init.fnl:21")
  handlers[name] = {}
  return nil
end
local function ensure_handler_group(name)
  _G.assert((nil ~= name), "Missing argument name on /var/home/david/Worktrees/setup.nvim/fnl/setup/init.fnl:24")
  return assert(handlers[name], ("no handler group: " .. name))
end
local function define_handler(group, handler_name, config)
  _G.assert((nil ~= config), "Missing argument config on /var/home/david/Worktrees/setup.nvim/fnl/setup/init.fnl:27")
  _G.assert((nil ~= handler_name), "Missing argument handler-name on /var/home/david/Worktrees/setup.nvim/fnl/setup/init.fnl:27")
  _G.assert((nil ~= group), "Missing argument group on /var/home/david/Worktrees/setup.nvim/fnl/setup/init.fnl:27")
  ensure_handler_group(group)
  assert(config.fn, ("no handler function: " .. handler_name))
  return table.insert(handlers[group], {handler_name, config})
end
local function call_handlers(group_name, ...)
  local rest = {...}
  _G.assert((nil ~= rest), "Missing argument rest on /var/home/david/Worktrees/setup.nvim/fnl/setup/init.fnl:32")
  _G.assert((nil ~= group_name), "Missing argument group-name on /var/home/david/Worktrees/setup.nvim/fnl/setup/init.fnl:32")
  ensure_handler_group(group_name)
  for _, _6_ in ipairs(handlers[group_name]) do
    local _0 = _6_[1]
    local handler = _6_[2]
    handler.fn(unpack(rest))
  end
  return nil
end
local function keymap_handler(_7_)
  local _3fconfig = _7_["keymap"]
  local config
  do
    local _8_ = type(_3fconfig)
    if (_8_ == "function") then
      config = _3fconfig()
    else
      local _ = _8_
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
define_handler_group("nvim")
local function _13_(_12_)
  local _3fconfig = _12_["colorscheme"]
  local and_14_ = (nil ~= _3fconfig)
  if and_14_ then
    local str = _3fconfig
    and_14_ = (type(str) == "string")
  end
  if and_14_ then
    local str = _3fconfig
    ensure_plugin(str)
    require(str).setup({})
    return vim.cmd.colorscheme(str)
  else
    return nil
  end
end
define_handler("nvim", "colorscheme", {fn = _13_})
local function _18_(_17_)
  local _3fconfig = _17_["g"]
  for key, val in pairs(_3fconfig) do
    vim.g[key] = val
  end
  return nil
end
define_handler("nvim", "g", {fn = _18_})
local function _20_(_19_)
  local _3fconfig = _19_["opt"]
  for key, val in pairs(_3fconfig) do
    vim.opt[key] = val
  end
  return nil
end
define_handler("nvim", "opt", {fn = _20_})
define_handler("nvim", "keymap", {fn = keymap_handler})
define_handler_group("plugin")
local function _21_(_3fconfig, plugin)
  _G.assert((nil ~= plugin), "Missing argument plugin on /var/home/david/Worktrees/setup.nvim/fnl/setup/init.fnl:82")
  return ensure_plugin(plugin, _3fconfig)
end
define_handler("plugin", "ensure", {fn = _21_})
local function _23_(_22_, plugin)
  local _3fopts = _22_["opt"]
  _G.assert((nil ~= plugin), "Missing argument plugin on /var/home/david/Worktrees/setup.nvim/fnl/setup/init.fnl:86")
  if (_3fopts ~= false) then
    local _24_ = require(plugin).setup
    if (_24_ == nil) then
      return nil
    elseif (nil ~= _24_) then
      local setup = _24_
      return setup((_3fopts or {}))
    else
      return nil
    end
  else
    return nil
  end
end
define_handler("plugin", "opt", {fn = _23_})
define_handler("plugin", "keymap", {fn = keymap_handler})
define_handler_group("filetype")
local function _28_(_27_, ft)
  local _3fconfig = _27_["plugin"]
  _G.assert((nil ~= ft), "Missing argument ft on /var/home/david/Worktrees/setup.nvim/fnl/setup/init.fnl:100")
  if _3fconfig then
    local group_name = (ft .. "-ft-plugin")
    local group = vim.api.nvim_create_augroup(group_name, {clear = true})
    for key, val in pairs((_3fconfig or {})) do
      local function _29_()
        return call_handlers("plugin", val, key)
      end
      vim.api.nvim_create_autocmd("FileType", {pattern = ft, callback = _29_, group = group})
    end
    return nil
  else
    return nil
  end
end
define_handler("filetype", "plugin", {fn = _28_})
local function _31_(_config, ft)
  _G.assert((nil ~= ft), "Missing argument ft on /var/home/david/Worktrees/setup.nvim/fnl/setup/init.fnl:113")
  if (ft ~= "*") then
    local group = vim.api.nvim_create_augroup((ft .. "-ft-lang"), {clear = true})
    local function _32_()
      return vim.treesitter.start()
    end
    return vim.api.nvim_create_autocmd("FileType", {pattern = ft, callback = _32_, group = group})
  else
    return nil
  end
end
define_handler("filetype", "lang", {fn = _31_})
local function _35_(_34_, ft)
  local _3fconfig = _34_["conform"]
  _G.assert((nil ~= ft), "Missing argument ft on /var/home/david/Worktrees/setup.nvim/fnl/setup/init.fnl:124")
  if _3fconfig then
    local conform = require("conform")
    conform.formatters_by_ft[ft] = _3fconfig.formatter
    return nil
  else
    return nil
  end
end
define_handler("filetype", "conform", {fn = _35_})
local function setup(name, _3fconfig)
  _G.assert((nil ~= name), "Missing argument name on /var/home/david/Worktrees/setup.nvim/fnl/setup/init.fnl:131")
  local config = (_3fconfig or {})
  if (name == "nvim") then
    return call_handlers("nvim", config)
  elseif ((_G.type(name) == "table") and (name[1] == "filetype") and (nil ~= name[2])) then
    local ft = name[2]
    return call_handlers("filetype", config, ft)
  else
    local _ = name
    return call_handlers("plugin", config, name)
  end
end
return {setup = setup}
