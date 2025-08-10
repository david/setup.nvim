(local {: define-component : define-trait : apply-traits}
       (require :setup.core))

(define-component :filetype)

(define-trait :filetype
  :plugin
  {:fn (lambda [{:plugin ?config} ft]
         (when ?config
           (let [group-name (.. ft :-ft-plugin)
                 group (vim.api.nvim_create_augroup group-name {:clear true})]
             (each [key val (pairs (or ?config {}))]
               (vim.api.nvim_create_autocmd :FileType
                                            {:pattern ft
                                             :callback #(apply-traits :plugin
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

