-- [nfnl] fnl/setup/components/plugin.fnl
local _local_1_ = require("setup.core")
local define_component = _local_1_["define-component"]
local define_trait = _local_1_["define-trait"]
local util = require("setup.util")
define_component("plugin")
local function _2_(_3fconfig, plugin)
  _G.assert((nil ~= plugin), "Missing argument plugin on /var/home/david/Worktrees/setup.nvim/fnl/setup/components/plugin.fnl:8")
  return util["ensure-plugin"](plugin, _3fconfig)
end
define_trait("plugin", "ensure", {fn = _2_})
local function _4_(_3_, plugin)
  local _3fopts = _3_["opt"]
  _G.assert((nil ~= plugin), "Missing argument plugin on /var/home/david/Worktrees/setup.nvim/fnl/setup/components/plugin.fnl:12")
  if (_3fopts ~= false) then
    local _5_ = require(plugin).setup
    if (_5_ == nil) then
      return nil
    elseif (nil ~= _5_) then
      local setup = _5_
      return setup((_3fopts or {}))
    else
      return nil
    end
  else
    return nil
  end
end
define_trait("plugin", "opt", {fn = _4_})
return define_trait("plugin", "keymap", {fn = util["keymap-handler"]})
