# setup.nvim

A simple Neovim plugin for declarative configuration.

`setup.nvim` provides a single function, `setup`, to configure your Neovim, plugin, and filetype settings, making it easier to have your Neovim config organized in one place.

## Installation

TBD

## Usage

```lua
local setup = require("setup").setup

-- configure Neovim
setup("nvim", {
  colorscheme = "gruvbox",

  g = {
    mapleader = " ",
    ...
  },

  opt = {
    number = true,
    relativenumber = true,
    ...
  },

  keymap = {
    "<Esc>" = "<cmd>nohlsearch<cr>",
    ...
  }
})

-- configure a plugin
setup("snacks", {
  opt = {
    dashboard = {
      sections = {
        ...
      },
    },
    indent = {},
    picker = {},
    ...
  },

  keymap = {
    "<D-/>" = function() Snacks.picker.grep() end
    "<D-f>" = function()
      Snacks.picker.smart({
        multi = { "buffers", "files" },
        matcher = { cwd_bonus = true }
      })
    end
  },
})
```
