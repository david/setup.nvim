-- [nfnl] fnl/setup/components/filetype.fnl
local _local_1_ = require("setup.core")
local define_component = _local_1_["define-component"]
local define_trait = _local_1_["define-trait"]
local apply_traits = _local_1_["apply-traits"]
define_component("filetype")
local function _3_(_2_, ft)
  local _3fconfig = _2_["plugin"]
  _G.assert((nil ~= ft), "Missing argument ft on /var/home/david/Worktrees/setup.nvim/fnl/setup/components/filetype.fnl:8")
  if _3fconfig then
    local group_name = (ft .. "-ft-plugin")
    local group = vim.api.nvim_create_augroup(group_name, {clear = true})
    for key, val in pairs((_3fconfig or {})) do
      local function _4_()
        return apply_traits("plugin", val, key)
      end
      vim.api.nvim_create_autocmd("FileType", {pattern = ft, callback = _4_, group = group})
    end
    return nil
  else
    return nil
  end
end
define_trait("filetype", "plugin", {fn = _3_})
local function _6_(_config, ft)
  _G.assert((nil ~= ft), "Missing argument ft on /var/home/david/Worktrees/setup.nvim/fnl/setup/components/filetype.fnl:21")
  if (ft ~= "*") then
    local group = vim.api.nvim_create_augroup((ft .. "-ft-lang"), {clear = true})
    local function _7_()
      return vim.treesitter.start()
    end
    return vim.api.nvim_create_autocmd("FileType", {pattern = ft, callback = _7_, group = group})
  else
    return nil
  end
end
define_trait("filetype", "lang", {fn = _6_})
local function _10_(_9_, ft)
  local _3fconfig = _9_["conform"]
  _G.assert((nil ~= ft), "Missing argument ft on /var/home/david/Worktrees/setup.nvim/fnl/setup/components/filetype.fnl:32")
  if _3fconfig then
    local conform = require("conform")
    conform.formatters_by_ft[ft] = _3fconfig.formatter
    return nil
  else
    return nil
  end
end
return define_trait("filetype", "conform", {fn = _10_})
