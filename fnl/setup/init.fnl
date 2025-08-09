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

(local handlers {})

(lambda define-handler-group [name]
  (set (. handlers name) {}))

(lambda ensure-handler-group [name]
  (assert (. handlers name) (.. "no handler group: " name)))

(lambda define-handler [group handler-name config]
  (ensure-handler-group group)
  (assert (. config :fn) (.. "no handler function: " handler-name))
  (table.insert (. handlers group) [handler-name config]))

(lambda call-handlers [group-name & rest]
  (ensure-handler-group group-name)
  (each [_ [_ handler] (ipairs (. handlers group-name))]
    (handler.fn (unpack rest))))

;;;; reusable handlers

(lambda keymap-handler [{:keymap ?config}]
  (let [config (case (type ?config)
                 :function (?config)
                 _ ?config)]
    (when config
      (each [key val (pairs config)]
        (case val
          {: cmd : mode} (vim.keymap.set mode key cmd)
          cmd (vim.keymap.set :n key cmd))))))

;;;; group

(define-handler-group :nvim)

(define-handler :nvim
  :colorscheme
  {:fn (lambda [{:colorscheme ?config}]
         (case ?config
           (where str (= (type str) :string)) (do
                                                (ensure-plugin str)
                                                ((. (require str) :setup) {})
                                                (vim.cmd.colorscheme str))))})

(define-handler :nvim
  :g
  {:fn (lambda [{:g ?config}]
         (each [key val (pairs ?config)]
           (set (. vim.g key) val)))})

(define-handler :nvim
  :opt
  {:fn (lambda [{:opt ?config}]
         (each [key val (pairs ?config)]
           (set (. vim.opt key) val)))})

(define-handler :nvim :keymap {:fn keymap-handler})

;;;; group

(define-handler-group :plugin)

(define-handler :plugin
  :ensure
  {:fn (lambda [?config plugin] (ensure-plugin plugin ?config))})

(define-handler :plugin
  :opt
  {:fn (lambda [{:opt ?opts} plugin]
         (when (not= ?opts false)
           (case (. (require plugin) :setup)
             nil nil
             setup (setup (or ?opts {})))))})

(define-handler :plugin :keymap {:fn keymap-handler})

;;;; group

(define-handler-group :filetype)

(define-handler :filetype
  :plugin
  {:fn (lambda [{:plugin ?config} ft]
         (when ?config
           (let [group-name (.. ft :-ft-plugin)
                 group (vim.api.nvim_create_augroup group-name {:clear true})]
             (each [key val (pairs (or ?config {}))]
               (vim.api.nvim_create_autocmd :FileType
                                            {:pattern ft
                                             :callback #(call-handlers :plugin
                                                                       val key)
                                             : group})))))})

(define-handler :filetype
  :lang
  {:fn (lambda [_config ft]
         (when (not= ft "*")
           (let [group (vim.api.nvim_create_augroup (.. ft :-ft-lang)
                                                    {:clear true})]
             (vim.api.nvim_create_autocmd :FileType
                                          {:pattern ft
                                           :callback #(vim.treesitter.start)
                                           : group}))))})

(define-handler :filetype
  :conform
  {:fn (lambda [{:conform ?config} ft]
         (when ?config
           (let [conform (require :conform)]
             (set (. conform.formatters_by_ft ft) (. ?config :formatter)))))})

;;;; setup

(lambda setup [name ?config]
  (let [config (or ?config {})]
    (case name
      :nvim (call-handlers :nvim config)
      [:filetype ft] (call-handlers :filetype config ft)
      _ (call-handlers :plugin config name))))

;; exports

{: setup}
