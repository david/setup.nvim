-- [nfnl] fnl/setup/core.fnl
local components = {}
local function define_component(name)
  components[name] = {}
  return nil
end
local function ensure_component(name)
  return assert(components[name], ("no component defined: " .. name))
end
local function define_trait(component_name, trait_name, config)
  ensure_component(component_name)
  assert(config.fn, ("no trait function: " .. trait_name))
  return table.insert(components[component_name], {trait_name, config})
end
local function apply_traits(component_name, ...)
  local rest = {...}
  ensure_component(component_name)
  for _, _1_ in ipairs(components[component_name]) do
    local _0 = _1_[1]
    local trait = _1_[2]
    trait.fn(unpack(rest))
  end
  return nil
end
return {["define-component"] = define_component, ["define-trait"] = define_trait, ["apply-traits"] = apply_traits}
