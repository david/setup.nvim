(local {: apply-traits} (require :setup.core))

(require :setup.components.nvim)
(require :setup.components.plugin)
(require :setup.components.filetype)

(fn setup [name ?config]
  (let [config (or ?config {})]
    (case name
      :nvim (apply-traits :nvim config)
      [:filetype ft] (apply-traits :filetype config ft)
      _ (apply-traits :plugin config name))))

{: setup}

