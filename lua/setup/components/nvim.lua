-- [nfnl] fnl/setup/components/nvim.fnl
local _local_1_ = require("setup.core")
local define_component = _local_1_["define-component"]
local define_trait = _local_1_["define-trait"]
local _local_2_ = require("setup.util")
local ensure_plugin = _local_2_["ensure-plugin"]
local keymap_handler = _local_2_["keymap-handler"]
define_component("nvim")
local function _4_(_3_)
  local _3fconfig = _3_["colorscheme"]
  local and_5_ = (nil ~= _3fconfig)
  if and_5_ then
    local str = _3fconfig
    and_5_ = (type(str) == "string")
  end
  if and_5_ then
    local str = _3fconfig
    ensure_plugin(str)
    require(str).setup({})
    return vim.cmd.colorscheme(str)
  else
    return nil
  end
end
define_trait("nvim", "colorscheme", {fn = _4_})
local function _9_(_8_)
  local _3fconfig = _8_["g"]
  for key, val in pairs(_3fconfig) do
    vim.g[key] = val
  end
  return nil
end
define_trait("nvim", "g", {fn = _9_})
local function _11_(_10_)
  local _3fconfig = _10_["opt"]
  for key, val in pairs(_3fconfig) do
    vim.opt[key] = val
  end
  return nil
end
define_trait("nvim", "opt", {fn = _11_})
return define_trait("nvim", "keymap", {fn = keymap_handler})
