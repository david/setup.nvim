-- [nfnl] fnl/setup/init.fnl
local _local_1_ = require("setup.core")
local apply_traits = _local_1_["apply-traits"]
require("setup.components.nvim")
require("setup.components.plugin")
require("setup.components.filetype")
local function setup(name, _3fconfig)
  local config = (_3fconfig or {})
  if (name == "nvim") then
    return apply_traits("nvim", config)
  elseif ((_G.type(name) == "table") and (name[1] == "filetype") and (nil ~= name[2])) then
    local ft = name[2]
    return apply_traits("filetype", config, ft)
  else
    local _ = name
    return apply_traits("plugin", config, name)
  end
end
return {setup = setup}
