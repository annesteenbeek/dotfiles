return {
  { lazy = true, "nvim-lua/plenary.nvim" },

  { "nvim-tree/nvim-web-devicons", opts = {} },
  { "echasnovski/mini.statusline", opts = {} },
  { "lewis6991/gitsigns.nvim", opts = {} },

  "EdenEast/nightfox.nvim",

  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "b0o/nvim-tree-preview.lua",
        -- Position is set here because the plugin's own calculation reads
        -- require("nvim-tree").config, which newer nvim-tree no longer has.
        opts = {
          win_position = {
            row = function(tree_win, size)
              local cursor = vim.api.nvim_win_get_cursor(tree_win)[1] - vim.fn.line("w0", tree_win)
              local bottom = vim.o.lines - 1 - vim.api.nvim_win_get_position(tree_win)[1]
              return math.max(0, math.min(cursor, bottom - size.height - 2))
            end,
            col = function(tree_win)
              return vim.fn.winwidth(tree_win) + 1
            end,
          },
        },
      },
    },
    opts = {
      renderer = {
        highlight_git = "name", -- colour file names by git status
        icons = {
          git_placement = "right_align", -- default git icons, at the far right
        },
      },
      on_attach = function(bufnr)
        local api = require "nvim-tree.api"
        local preview = require "nvim-tree-preview"
        api.config.mappings.default_on_attach(bufnr)

        local function map(key, fn, desc)
          vim.keymap.set("n", key, fn, { desc = "nvim-tree: " .. desc, buffer = bufnr, nowait = true, silent = true })
        end

        -- P: preview follows the cursor; Esc stops it
        map("P", preview.watch, "Preview (follow cursor)")
        map("<Esc>", preview.unwatch, "Close preview")
        map("<C-f>", function() return preview.scroll(4) end, "Scroll preview down")
        map("<C-b>", function() return preview.scroll(-4) end, "Scroll preview up")

        -- Tab: preview a file once, or open/close a folder
        map("<Tab>", function()
          local ok, node = pcall(api.tree.get_node_under_cursor)
          if ok and node then
            if node.type == "directory" then
              api.node.open.edit()
            else
              preview.node(node, { toggle_focus = true })
            end
          end
        end, "Preview")
      end,
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate | TSInstallAll",
    opts = function()
      return require "plugins.configs.treesitter"
    end,
  },

  {
    "akinsho/bufferline.nvim",
    opts = require "plugins.configs.bufferline",
  },

  -- we use blink plugin only when in insert mode
  -- so lets lazyload it at InsertEnter event
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = "InsertEnter",
    dependencies = {
      "rafamadriz/friendly-snippets",

      -- snippets engine
      {
        "L3MON4D3/LuaSnip",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },

      -- autopairs , autocompletes ()[] etc
      { "windwp/nvim-autopairs", opts = {} },
    },
    -- made opts a function cuz cmp config calls cmp module
    -- and we lazyloaded cmp so we dont want that file to be read on startup!
    opts = function()
      return require "plugins.configs.blink"
    end,
  },

  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    cmd = { "Mason", "MasonInstall" },
    opts = {},
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
    end,
  },

  {
    "stevearc/conform.nvim",
    opts = require "plugins.configs.conform",
  },

  {
    "nvimdev/indentmini.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },

  -- files finder etc
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    opts = require "plugins.configs.telescope",
  },

}
