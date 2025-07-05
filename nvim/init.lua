-- config :yum:
-- enable logging

vim.lsp.set_log_level("debug")

-- [[ keybinds ]]
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local NORMAL_MODE_KEY = "kj"
local options = { noremap = true }
vim.keymap.set("i", NORMAL_MODE_KEY, "<cmd>nohlsearch<CR><Esc>", options)


-- [[ functional options ]]
-- hightlight on yap
-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.diagnostic.config({
  virtual_text = true,
  virtual_lines = false
})

vim.opt.number = true
vim.opt.showmode = false
vim.opt.breakindent = true
vim.opt.signcolumn = 'yes'

vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- -- Show which line your cursor is on
-- vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- use spaces instead of tabs for lua files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
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
        { out, "WarningMsg" },
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
    {
      "nvim-treesitter/nvim-treesitter",
      branch = 'master',
      lazy = false,
      build = ":TSUpdate"
    },
    {
      "ellisonleao/gruvbox.nvim",
      priority = 1000 ,
      config = true,
      opts = {}
    },
    {
      "mason-org/mason.nvim",
      opts = {
        ensure_installed = {
          "luals",
          "pyright",
          "clangd",
        }
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
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "gruvbox" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})
vim.lsp.enable({"luals", "pyright"})
-- lsp
vim.api.nvim_create_autocmd('LspAttach',{
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, {autotrigger = false})
    end
  end,
})




-- gruvbox
-- Default options:
require("gruvbox").setup({
  terminal_colors = true, -- add neovim terminal colors
  undercurl = true,
  underline = true,
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
  contrast = "", -- can be "hard", "soft" or empty string
  palette_overrides = {},
  overrides = {},
  dim_inactive = false,
  transparent_mode = false,
})



vim.cmd([[colorscheme gruvbox]])
