(lambda ensure-plugin [plugin ?config]
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
                              ensure-plugin))))]
    (each [_ dep (ipairs (or spec.dependencies []))]
      (ensure-plugin dep))
    (vim.pack.add [(. spec :pack)])
    spec))

(local traits {})

(lambda define-trait-component [name]
  (set (. traits name) {}))

(lambda ensure-trait-component [name]
  (assert (. traits name) (.. "no trait component: " name)))

(lambda define-trait [component trait-name config]
  (ensure-trait-component component)
  (assert (. config :fn) (.. "no trait function: " trait-name))
  (table.insert (. traits component) [trait-name config]))

(lambda call-traits [component-name & rest]
  (ensure-trait-component component-name)
  (each [_ [_ trait] (ipairs (. traits component-name))]
    (trait.fn (unpack rest))))

;;;; reusable traits

(lambda keymap-trait [{:keymap ?config}]
  (let [config (case (type ?config)
                 :function (?config)
                 _ ?config)]
    (when config
      (each [key val (pairs config)]
        (case val
          {: cmd : mode} (vim.keymap.set mode key cmd)
          cmd (vim.keymap.set :n key cmd))))))

;;;; component

(define-trait-component :nvim)

(define-trait :nvim
  :colorscheme
  {:fn (lambda [{:colorscheme ?config}]
         (case ?config
           (where str (= (type str) :string)) (do
                                                (ensure-plugin str)
                                                ((. (require str) :setup) {})
                                                (vim.cmd.colorscheme str))))})

(define-trait :nvim
  :g
  {:fn (lambda [{:g ?config}]
         (each [key val (pairs ?config)]
           (set (. vim.g key) val)))})

(define-trait :nvim
  :opt
  {:fn (lambda [{:opt ?config}]
         (each [key val (pairs ?config)]
           (set (. vim.opt key) val)))})

(define-trait :nvim :keymap {:fn keymap-trait})

;;;; component

(define-trait-component :plugin)

(define-trait :plugin
  :ensure
  {:fn (lambda [?config plugin] (ensure-plugin plugin ?config))})

(define-trait :plugin
  :opt
  {:fn (lambda [{:opt ?opts} plugin]
         (when (not= ?opts false)
           (case (. (require plugin) :setup)
             nil nil
             setup (setup (or ?opts {})))))})

(define-trait :plugin :keymap {:fn keymap-trait})

;;;; component

(define-trait-component :filetype)

(define-trait :filetype
  :plugin
  {:fn (lambda [{:plugin ?config} ft]
         (when ?config
           (let [group-name (.. ft :-ft-plugin)
                 group (vim.api.nvim_create_augroup group-name {:clear true})]
             (each [key val (pairs (or ?config {}))]
               (vim.api.nvim_create_autocmd :FileType
                                            {:pattern ft
                                             :callback #(call-traits :plugin
                                                                     val key)
                                             : group})))))})

(define-trait :filetype
  :lang
  {:fn (lambda [_config ft]
         (when (not= ft "*")
           (let [group (vim.api.nvim_create_augroup (.. ft :-ft-lang)
                                                    {:clear true})]
             (vim.api.nvim_create_autocmd :FileType
                                          {:pattern ft
                                           :callback #(vim.treesitter.start)
                                           : group}))))})

(define-trait :filetype
  :conform
  {:fn (lambda [{:conform ?config} ft]
         (when ?config
           (let [conform (require :conform)]
             (set (. conform.formatters_by_ft ft) (. ?config :formatter)))))})

;;;; setup

(lambda setup [name ?config]
  (let [config (or ?config {})]
    (case name
      :nvim (call-traits :nvim config)
      [:filetype ft] (call-traits :filetype config ft)
      _ (call-traits :plugin config name))))

;; exports

{: setup}
