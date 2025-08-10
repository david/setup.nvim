(local components {})

(fn define-component [name]
  (set (. components name) {}))

(fn ensure-component [name]
  (assert (. components name) (.. "no component defined: " name)))

(fn define-trait [component-name trait-name config]
  (ensure-component component-name)
  (assert (. config :fn) (.. "no trait function: " trait-name))
  (table.insert (. components component-name) [trait-name config]))

(fn apply-traits [component-name & rest]
  (ensure-component component-name)
  (each [_ [_ trait] (ipairs (. components component-name))]
    (trait.fn (unpack rest))))

{: define-component : define-trait : apply-traits}
