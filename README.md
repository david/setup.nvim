# setup.nvim

A simple Neovim plugin for declarative configuration.

`setup.nvim` provides a single function, `setup`, to configure your Neovim, plugin, and filetype settings, making it easier to have your Neovim config organized in one place.

## Installation

TBD

## Usage

The core of `setup.nvim` is the `setup` function, which takes two arguments: the name of the component to configure, and a configuration table.

```lua
local setup = require("setup").setup
```

### Configuring Neovim

To configure Neovim's core settings, use the `:nvim` component:

```lua
setup(:nvim, {
  colorscheme = "gruvbox",

  g = {
    mapleader = " ",
  },

  opt = {
    number = true,
    relativenumber = true,
  },

  keymap = {
    ["<Esc>"] = "<cmd>nohlsearch<cr>",
  },
})
```

The `:nvim` component has the following traits:

*   `:colorscheme`: Sets the colorscheme. It ensures the plugin is installed and sets it up.
*   `:g`: Sets global variables (`vim.g`).
*   `:opt`: Sets Neovim options (`vim.opt`).
*   `:keymap`: Sets keymaps.

### Configuring Plugins

To configure a plugin, use the plugin's name as the component:

```lua
setup("snacks", {
  opt = {
    dashboard = {
      sections = {
        -- ...
      },
    },
  },
  keymap = {
    ["<D-/>"] = function() require("snacks").picker.grep() end,
  },
})
```

The plugin component has the following traits:

*   `:ensure`: Ensures the plugin is installed (`true` by default).
*   `:opt`: Passes the configuration table to the plugin's `setup` function.
*   `:keymap`: Sets keymaps for the plugin.

### Configuring Filetypes

To configure filetype-specific settings, use the `:filetype` component with the filetype as the second argument:

```lua
setup({"filetype", "fennel"}, {
  plugin = {
    nfnl = {},
  },
  conform = {
    formatter = "fnlfmt",
  },
})
```

The `:filetype` component has the following traits:

*   `:plugin`: Configures plugins for the specific filetype.
*   `:lang`: Starts the Treesitter language server for the filetype.
*   `:conform`: Configures the formatter for the filetype with `conform.nvim`.

