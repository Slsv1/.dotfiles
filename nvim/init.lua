-- config :yum:
-- enable logging

vim.lsp.set_log_level("debug")

-- [[ keybinds ]]
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local NORMAL_MODE_KEY = "kj"
local options = { noremap = true }
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")

-- vim.keymap.set("n", "<C-b>", "<C-b>zz")
-- vim.keymap.set("n", "<C-f>", "<C-f>zz")
vim.keymap.set("i", NORMAL_MODE_KEY, "<cmd>nohlsearch<CR><Esc>", options)
vim.diagnostic.config {
  virtual_lines = false,
  virtual_text = true
}
vim.keymap.set('n', '<leader>d', function()
    vim.diagnostic.config {
        virtual_lines = not vim.diagnostic.config().virtual_lines,
        virtual_text = not vim.diagnostic.config().virtual_text,
     }
end, { desc = 'Toggle diagnostic virtual lines and virtual text' })

-- netrw settigns but i use oil now
-- vim.keymap.set("n", "<leader>e", ":Ex<CR>")
-- vim.g.netrw_banner = 0-- gets rid of the annoying banner for netrw
-- vim.g.netrw_liststyle=3-- tree style view in netrw
-- hightlight on yap
-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
-- vim.api.nvim_get_hl(0, "#Normal#")
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.termguicolors = true -- idk if i need this one but just in case
vim.o.number = true
vim.o.breakindent = true
vim.o.signcolumn = 'yes'
vim.o.winborder = 'solid'

vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- -- Show which line your cursor is on
-- vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10


-- use spaces instead of tabs for lua files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', {}),
  callback = function(args)
  end,
})

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- require('lazydev').find_workspace(buf?)
-- Setup lazy.nvim plugins
require("lazy").setup({
  spec = {
    -- add your plugins here
    -- {
    --   "nvim-treesitter/nvim-treesitter",
    --   branch = 'master',
    --   lazy = false,
    --   build = ":TSUpdate"
    -- },
    {
      "ellisonleao/gruvbox.nvim",
      priority = 1000,
      config = true,
      opts = {}
    },
    {
      'stevearc/oil.nvim',
      ---@module 'oil'
      ---@type oil.SetupOpts
      opts = {},
      -- Optional dependencies
      -- dependencies = { { "echasnovski/mini.icons", opts = {} } },
      dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
      -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
      lazy = false,
      config = function ()
        require("oil").setup()
        vim.keymap.set("n", "<leader>e", "<CMD>Oil<CR>", { desc = "Open parent directory" })
      end
    },
    {
      "neovim/nvim-lspconfig",
      dependencies = {
        {
          "mason-org/mason.nvim",
          opts = {
            ensure_installed = {
              "lua_ls",
              "pyright",
              "clangd",
            }
          }
        },
      }
    },
    {
      "folke/lazydev.nvim",
      ft = "lua", -- only load on lua files
      opts = {
        library = {
          -- See the configuration section for more details
          -- Load luvit types when the `vim.uv` word is found
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        }
      },
    },
    {
      'saghen/blink.cmp',
      -- optional: provides snippets for the snippet source
      dependencies = { 'rafamadriz/friendly-snippets' },

      -- use a release tag to download pre-built binaries
      version = '1.*',
      -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
      -- build = 'cargo build --release',
      -- If you use nix, you can build from source using latest nightly rust with:
      -- build = 'nix run .#build-plugin',

      ---@module 'blink.cmp'
      ---@type blink.cmp.Config
      opts = {
        -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
        -- 'super-tab' for mappings similar to vscode (tab to accept)
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- All presets have the following mappings:
        -- C-space: Open menu or open docs if already open
        -- C-n/C-p or Up/Down: Select next/previous item
        -- C-e: Hide menu
        -- C-k: Toggle signature help (if signature.enabled = true)
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        keymap = { preset = 'default' },


        appearance = {
          -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
          -- Adjusts spacing to ensure icons are aligned
          nerd_font_variant = 'mono'
        },

        -- (Default) Only show the documentation popup when manually triggered
        completion = {
          menu = {
            border = "padded"
          },
          documentation = { auto_show = true } },

        -- Default list of enabled providers defined so that you can extend it
        -- elsewhere in your config, without redefining it, due to `opts_extend`
        sources = {
          default = { 'lsp', 'path', 'snippets', 'buffer' },
        },

        -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
        -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
        -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
        --
        -- See the fuzzy documentation for more information
        fuzzy = { implementation = "prefer_rust_with_warning" }
      },
      opts_extend = { "sources.default" }
    }
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "gruvbox" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

vim.lsp.enable({ "lua_ls", "pyright" })

require("gruvbox").setup({
  terminal_colors = true, -- add neovim terminal colors
  undercurl = true,
  underline = false,
  bold = true,
  italic = {
    strings = false,
    emphasis = false,
    comments = false,
    operators = false,
    folds = false,
  },
  strikethrough = true,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  inverse = true, -- invert background for search, diffs, statuslines and errors
  contrast = "hard",  -- can be "hard", "soft" or empty string
  palette_overrides = {},
  overrides = {},
  dim_inactive = false,
  transparent_mode = false,
})


vim.cmd([[colorscheme gruvbox]])
local modes = {
  ["n"] = "NORMAL",
  ["no"] = "NORMAL",
  ["v"] = "VISUAL",
  ["V"] = "VISUAL LINE",
  ["␖"] = "VISUAL BLOCK",
  ["s"] = "SELECT",
  ["S"] = "SELECT LINE",
  ["␓"] = "SELECT BLOCK",
  ["i"] = "INSERT",
  ["ic"] = "INSERT",
  ["R"] = "REPLACE",
  ["Rv"] = "VISUAL REPLACE",
  ["c"] = "COMMAND",
  ["cv"] = "VIM EX",
  ["ce"] = "EX",
  ["r"] = "PROMPT",
  ["rm"] = "MOAR",
  ["r?"] = "CONFIRM",
  ["!"] = "SHELL",
  ["t"] = "TERMINAL",
}
local function mode()
  local current_mode = vim.api.nvim_get_mode().mode
  return string.format("%s", modes[current_mode]):upper()
end

vim.keymap.set("n", "<leader>t", function()
end)


local function get_color(group, attr)
    return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(group)), attr)
end
local bg_color = get_color("Normal", "bg#")
local fg_color = get_color("Normal", "fg#")
local accent_color = "#689d6a"
vim.print('debug'..bg_color)
vim.cmd("highlight StatusLine guibg="..bg_color.." guifg="..fg_color) -- active statusline style
vim.cmd("highlight StatusLineNC guibg="..bg_color.." guifg=".. fg_color) -- inactive statusline style
vim.cmd("highlight StatusLineInfo guifg=" .. fg_color ) -- inactive statusline style
vim.cmd("highlight StatusLineBold guifg=".. fg_color.. " gui=bold") -- inactive statusline style
vim.cmd("highlight Ruler guifg=Red")
--vim.o.rulerformat = "%#Ruler#%l,%c%V%=%P%%"

vim.o.laststatus=2
vim.o.showmode=false
vim.cmd("set fillchars=stlnc:-,stl:-")
vim.api.nvim_create_autocmd({"ModeChanged", "BufEnter", "WinEnter"}, {
  callback=function()
    vim.opt_local.statusline=""
    .."-"
    .."%#StatusLineBold#"
    .."%F" -- show file type
    .."%#StatusLineInfo#"
    .."-"
    .."%N" -- buffer number
    .."-"
    ..mode()
    .."%#StatusLine#"
    .."-"
    .."%=" -- move over to other edge of status line
    .."%#StatusLineInfo#"
    .."-%l/%L-%c-"
  end
})

vim.api.nvim_create_autocmd({"BufLeave", "WinLeave"}, {
  callback=function()
    vim.opt_local.statusline=""
    .."-"
    .."%F" -- show file type
    .." "
    .."%N" -- buffer number
    .."-"
  end
})

