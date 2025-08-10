(local {: define-component : define-trait} (require :setup.core))
(local util (require :setup.util))

(define-component :plugin)

(define-trait :plugin
  :ensure
  {:fn (lambda [?config plugin] (util.ensure-plugin plugin ?config))})

(define-trait :plugin
  :opt
  {:fn (lambda [{:opt ?opts} plugin]
         (when (not= ?opts false)
           (case (. (require plugin) :setup)
             nil nil
             setup (setup (or ?opts {})))))})

(define-trait :plugin :keymap {:fn util.keymap-handler})

