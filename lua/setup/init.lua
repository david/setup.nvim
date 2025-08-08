-- [nfnl] fnl/setup/init.fnl
local handlers = {}
local function define_handler_group(name)
  _G.assert((nil ~= name), "Missing argument name on /var/home/david/Worktrees/setup.nvim/fnl/setup/init.fnl:3")
  handlers[name] = {}
  return nil
end
local function ensure_handler_group(name)
  _G.assert((nil ~= name), "Missing argument name on /var/home/david/Worktrees/setup.nvim/fnl/setup/init.fnl:6")
  return assert(handlers[name], ("no handler group: " .. name))
end
local function define_handler(group, handler_name, config)
  _G.assert((nil ~= config), "Missing argument config on /var/home/david/Worktrees/setup.nvim/fnl/setup/init.fnl:9")
  _G.assert((nil ~= handler_name), "Missing argument handler-name on /var/home/david/Worktrees/setup.nvim/fnl/setup/init.fnl:9")
  _G.assert((nil ~= group), "Missing argument group on /var/home/david/Worktrees/setup.nvim/fnl/setup/init.fnl:9")
  ensure_handler_group(group)
  assert(config.fn, ("no handler function: " .. handler_name))
  handlers[group][handler_name] = config
  return nil
end
local function call_handlers(group_name, ...)
  local rest = {...}
  _G.assert((nil ~= rest), "Missing argument rest on /var/home/david/Worktrees/setup.nvim/fnl/setup/init.fnl:14")
  _G.assert((nil ~= group_name), "Missing argument group-name on /var/home/david/Worktrees/setup.nvim/fnl/setup/init.fnl:14")
  ensure_handler_group(group_name)
  for key, handler in pairs(handlers[group_name]) do
    handler.fn(unpack(rest))
  end
  return nil
end
local function keymap_handler(_1_)
  local _3fconfig = _1_["keymap"]
  if _3fconfig then
    for key, val in pairs(_3fconfig) do
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
local function _5_(_4_)
  local _3fconfig = _4_["colorscheme"]
  local and_6_ = (nil ~= _3fconfig)
  if and_6_ then
    local str = _3fconfig
    and_6_ = (type(str) == "string")
  end
  if and_6_ then
    local str = _3fconfig
    require(str).setup({})
    return vim.cmd.colorscheme(str)
  else
    return nil
  end
end
define_handler("nvim", "colorscheme", {fn = _5_})
local function _10_(_9_)
  local _3fconfig = _9_["g"]
  for key, val in pairs(_3fconfig) do
    vim.g[key] = val
  end
  return nil
end
define_handler("nvim", "g", {fn = _10_})
local function _12_(_11_)
  local _3fconfig = _11_["opt"]
  for key, val in pairs(_3fconfig) do
    vim.opt[key] = val
  end
  return nil
end
define_handler("nvim", "opt", {fn = _12_})
define_handler("nvim", "keymap", {fn = keymap_handler})
define_handler_group("plugin")
local function _14_(_13_, plugin)
  local _3fopts = _13_["opt"]
  _G.assert((nil ~= plugin), "Missing argument plugin on /var/home/david/Worktrees/setup.nvim/fnl/setup/init.fnl:60")
  local _15_ = require(plugin).setup
  if (nil ~= _15_) then
    local setup = _15_
    return setup((_3fopts or {}))
  else
    return nil
  end
end
define_handler("plugin", "opt", {fn = _14_})
define_handler("plugin", "keymap", {fn = keymap_handler})
define_handler_group("filetype")
local function _18_(_17_, ft)
  local _3fconfig = _17_["plugin"]
  _G.assert((nil ~= ft), "Missing argument ft on /var/home/david/Worktrees/setup.nvim/fnl/setup/init.fnl:72")
  if _3fconfig then
    local group_name = (ft .. "-ft-plugin")
    local group = vim.api.nvim_create_augroup(group_name, {clear = true})
    for key, val in pairs((_3fconfig or {})) do
      local function _19_()
        return require(key).setup(val)
      end
      vim.api.nvim_create_autocmd("FileType", {pattern = ft, callback = _19_, group = group})
    end
    return nil
  else
    return nil
  end
end
define_handler("filetype", "plugin", {fn = _18_})
local function _21_(_config, ft)
  _G.assert((nil ~= ft), "Missing argument ft on /var/home/david/Worktrees/setup.nvim/fnl/setup/init.fnl:85")
  if (ft ~= "*") then
    local group = vim.api.nvim_create_augroup((ft .. "-ft-lang"), {clear = true})
    local function _22_()
      return vim.treesitter.start()
    end
    return vim.api.nvim_create_autocmd("FileType", {pattern = ft, callback = _22_, group = group})
  else
    return nil
  end
end
define_handler("filetype", "lang", {fn = _21_})
local function _25_(_24_, ft)
  local _3fconfig = _24_["conform"]
  _G.assert((nil ~= ft), "Missing argument ft on /var/home/david/Worktrees/setup.nvim/fnl/setup/init.fnl:96")
  if _3fconfig then
    local conform = require("conform")
    conform.formatters_by_ft[ft] = _3fconfig.formatter
    return nil
  else
    return nil
  end
end
define_handler("filetype", "conform", {fn = _25_})
local function setup(name, _3fconfig)
  _G.assert((nil ~= name), "Missing argument name on /var/home/david/Worktrees/setup.nvim/fnl/setup/init.fnl:103")
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
