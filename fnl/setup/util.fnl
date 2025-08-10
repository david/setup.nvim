(local util {})

(lambda util.ensure-plugin [plugin ?config]
  (let [config (or ?config {})
        module (.. :setup.registry. plugin)
        spec (case (pcall require module)
               (true s) s
               rest (let [parts (vim.split plugin "."
                                           {:plain true :trimempty true})]
                      (case (length parts)
                        1 (error (.. "module not in registry: " plugin))
                        l (-> [(unpack parts 1 (- l 1))]
                              vim.iter
                              (: :join ".")
                              (util.ensure-plugin)))))]
    (each [_ dep (ipairs (or spec.dependencies []))]
      (util.ensure-plugin dep))
    (vim.pack.add [(. spec :pack)])
    spec))

(lambda util.keymap-handler [{:keymap ?config}]
  (let [config (case (type ?config)
                 :function (?config)
                 _ ?config)]
    (when config
      (each [key val (pairs config)]
        (case val
          {: cmd : mode} (vim.keymap.set mode key cmd)
          cmd (vim.keymap.set :n key cmd))))))

util

