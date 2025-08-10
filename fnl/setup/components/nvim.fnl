(local {: define-component : define-trait} (require :setup.core))
(local {: ensure-plugin : keymap-handler} (require :setup.util))

(define-component :nvim)

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

(define-trait :nvim :keymap {:fn keymap-handler})

