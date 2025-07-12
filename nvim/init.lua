-- config :yum:
-- enable logging


---@class cfg
local cfg = {
	colorscheme = "gruvbox",
	max_scroll_off = 10,
	plugins = {
		tree_sitter_languages = {
			"bash",
			"c",
			"diff",
			"html",
			"lua",
			"luadoc",
			"markdown",
			"markdown_inline",
			"query",
			"vim",
			"vimdoc",
		},
	},
	lsp = {
		active_servers = {
			"lua_ls",
			"pyright",
			"clangd",
			"cmake",
		},
		diagnostics = true,
		gray_out_unnecesary = false,
	},
	tab_config = {
		per_language_config = {
			python = {indent = 4, spaces = true},
			lua = {indent = 4, spaces = false},
			c = {indent = 4, spaces = true},
			cpp = {indent = 4, spaces = true},
		},
	},
	sign_column = {
		flat = true
	},
	cursor_line = true,
	custom_status_bar = true,
	use_system_clipboard = true,
	fancy_whitespace = true,
	keybinds = {
		center_when_jumping = true,
		leader = " ",
		normal_mode = "kj",
		format = "g=",
		lsp_go_definition = "gd",
		diagnostic_mode_toggle = "<leader>d",
	},
	misc = true,
}

-- vim.lsp.set_log_level("debug")

if cfg.keybinds then
	-- [[ keybinds ]]
	vim.g.mapleader = cfg.keybinds.leader
	vim.g.maplocalleader = cfg.keybinds.leader

	local options = { noremap = true }

	if cfg.keybinds.center_when_jumping then
		vim.keymap.set("n", "<C-u>", "<C-u>zz")
		vim.keymap.set("n", "<C-d>", "<C-d>zz")
	end
	vim.keymap.set("n", cfg.keybinds.lsp_go_definition, "<C-]>")
	vim.keymap.set("i", cfg.keybinds.normal_mode, "<cmd>nohlsearch<CR><Esc>", options)

	vim.keymap.set("n", cfg.keybinds.format, function()
		vim.lsp.buf.format()
		vim.print("buffer formatted")
	end)

	if cfg.lsp.diagnostics then
		vim.keymap.set("n", cfg.keybinds.diagnostic_mode_toggle, function()
			vim.diagnostic.config({
				virtual_lines = not vim.diagnostic.config().virtual_lines,
				virtual_text = not vim.diagnostic.config().virtual_text,
			})
		end, { desc = "Toggle diagnostic virtual lines and virtual text" })
	end
end

-- vim.keymap.set("n", "<C-b>", "<C-b>zz")
-- vim.keymap.set("n", "<C-f>", "<C-f>zz")
if cfg.lsp.diagnostics then
	vim.diagnostic.config({
		virtual_lines = false,
		virtual_text = true,
	})
end

if cfg.use_system_clipboard then
	vim.o.clipboard = vim.o.clipboard .. "unnamedplus"
end

-- netrw settigns but i use oil now
-- vim.keymap.set("n", "<leader>e", ":Ex<CR>")
-- vim.g.netrw_banner = 0-- gets rid of the annoying banner for netrw
-- vim.g.netrw_liststyle=3-- tree style view in netrw
-- hightlight on yap
-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
-- vim.api.nvim_get_hl(0, "#Normal#")
if cfg.misc then
	vim.o.ignorecase = true
	vim.o.smartcase = true

	vim.o.termguicolors = true -- idk if i need this one but just in case
	vim.o.number = true
	vim.o.breakindent = true
	-- Preview substitutions live, as you type!
	vim.o.inccommand = "split"
end

if cfg.sign_column then
	vim.o.signcolumn = "yes"
end

if cfg.fancy_whitespace then
	vim.opt.list = true
	vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
end

-- Minimal number of screen lines to keep above and below the cursor.
if cfg.max_scroll_off ~= nil then
	vim.o.scrolloff = cfg.max_scroll_off
end

if cfg.tab_config then
	-- default tab settings
	vim.o.tabstop = 4
	vim.o.shiftwidth = 4
	local function config_tabs(pattern, use_spaces, length)
		if use_spaces then
			vim.api.nvim_create_autocmd("FileType", {
				pattern = pattern,
				callback = function()
					vim.opt_local.expandtab = true
					vim.opt_local.shiftwidth = length
					vim.opt_local.softtabstop = length
				end,
			})
		else
			vim.api.nvim_create_autocmd("FileType", {
				pattern = pattern,
				callback = function()
					vim.opt_local.tabstop = length
					vim.opt_local.shiftwidth = length
				end,
			})
		end
	end
	for language, opts in pairs(cfg.tab_config.per_language_config) do
		config_tabs(language, opts.spaces, opts.indent)
	end
end

if cfg.plugins then
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

	local plugins = {
		-- add your plugins here
		{ -- Highlight, edit, and navigate code
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
			main = "nvim-treesitter.configs", -- Sets main module to use for opts
			-- [[ Configure Treesitter ]] See `:help nvim-treesitter`
			opts = {
				ensure_installed = {
					"bash",
					"c",
					"diff",
					"html",
					"lua",
					"luadoc",
					"markdown",
					"markdown_inline",
					"query",
					"vim",
					"vimdoc",
				},
				-- Autoinstall languages that are not installed
				auto_install = true,
				highlight = {
					enable = true,
					-- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
					--  If you are experiencing weird indenting issues, add the language to
					--  the list of additional_vim_regex_highlighting and disabled languages for indent.
					additional_vim_regex_highlighting = { "ruby" },
				},
				indent = { enable = true, disable = { "ruby" } },
			},
			-- There are additional nvim-treesitter modules that you can use to interact
			-- with nvim-treesitter. You should go explore a few and see what interests you:
			--
			--    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
			--    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
			--    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
		},
		{
			"ellisonleao/gruvbox.nvim",
			priority = 1000,
			config = function ()
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
					contrast = "hard", -- can be "hard", "soft" or empty string
					palette_overrides = {},
					overrides = {},
					dim_inactive = false,
					transparent_mode = false,
				})
			end,
			opts = {},
		},
		{
			"stevearc/oil.nvim",
			---@module 'oil'
			---@type oil.SetupOpts
			opts = {},
			-- Optional dependencies
			-- dependencies = { { "echasnovski/mini.icons", opts = {} } },
			dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
			-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
			lazy = false,
			config = function()
				require("oil").setup()
			end,
		},
		{
			"neovim/nvim-lspconfig",
			dependencies = {
				{
					"mason-org/mason.nvim",
					opts = {
						ensure_installed = cfg.lsp.active_servers,
					},
				},
			},
		},
		{
			"folke/lazydev.nvim",
			ft = "lua", -- only load on lua files
			opts = {
				library = {
					-- See the configuration section for more details
					-- Load luvit types when the `vim.uv` word is found
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},
		{
			"saghen/blink.cmp",
			-- optional: provides snippets for the snippet source
			dependencies = { "rafamadriz/friendly-snippets" },

			-- use a release tag to download pre-built binaries
			version = "1.*",
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
				keymap = { preset = "default" },

				appearance = {
					-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
					-- Adjusts spacing to ensure icons are aligned
					nerd_font_variant = "mono",
				},

				-- (Default) Only show the documentation popup when manually triggered
				completion = {
					menu = {
						border = "padded",
					},
					documentation = { auto_show = true },
				},

				-- Default list of enabled providers defined so that you can extend it
				-- elsewhere in your config, without redefining it, due to `opts_extend`
				sources = {
					default = { "lsp", "path", "snippets", "buffer" },
				},

				-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
				-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
				-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
				--
				-- See the fuzzy documentation for more information
				fuzzy = { implementation = "prefer_rust_with_warning" },
			},
			opts_extend = { "sources.default" },
		},
	}

	require("lazy").setup({
		-- Configure any other settings here. See the documentation for more details.
		-- colorscheme that will be used when installing plugins.
		spec = plugins,
		install = { colorscheme = { "gruvbox" } },
		-- automatically check for plugin updates
		checker = { enabled = true },
	})
end

if cfg.lsp then
	vim.lsp.enable(cfg.lsp.active_servers)
end

-- Visuals
----------


if cfg.colorscheme then
	vim.cmd("colorscheme " .. cfg.colorscheme)
end

-- disable grayed out functions when unused
if not cfg.lsp.gray_out_unnecesary then
	vim.cmd([[highlight DiagnosticUnnecessary guifg=NONE]])
end

local function get_color(group, attr)
	return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(group)), attr)
end


if cfg.custom_status_bar then
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

	-- get the normal colors
	local fg_color = get_color("Normal", "fg#")

	-- statusline colors
	vim.cmd("highlight StatusLine guibg=NONE" .. " guifg=" .. fg_color)   -- active statusline style
	vim.cmd("highlight StatusLineNC guibg=NONE" .. " guifg=" .. fg_color) -- inactive statusline style
	vim.cmd("highlight StatusLineInfo guifg=" .. fg_color)                -- inactive statusline style
	vim.cmd("highlight StatusLineBold guifg=" .. fg_color .. " gui=bold") -- inactive statusline style

	vim.o.laststatus = 2
	vim.o.showmode = false
	vim.cmd("set fillchars=stlnc:-,stl:-")
	vim.api.nvim_create_autocmd({ "ModeChanged", "BufEnter", "WinEnter" }, {
		callback = function()
			vim.opt_local.statusline = ""
				.. "-"
				.. "%#StatusLineBold#"
				.. "%F" -- show file type
				.. "%#StatusLineInfo#"
				.. "-"
				.. "%N" -- buffer number
				.. "-"
				.. mode()
				.. "%#StatusLine#"
				.. "-"
				.. "%=" -- move over to other edge of status line
				.. "%#StatusLineInfo#"
				.. "-%l/%L-%c-"
		end,
	})

	vim.api.nvim_create_autocmd({ "BufLeave", "WinLeave" }, {
		callback = function()
			vim.opt_local.statusline = ""
				.. "-"
				.. "%F" -- show file type
				.. " "
				.. "%N" -- buffer number
				.. "-"
		end,
	})
end

local function make_default_bg(group)
	local maybe_fg_color = get_color(group, "fg#")
	if #maybe_fg_color > 0 then
		vim.cmd("highlight " .. group .. " guibg=NONE" .. " guifg=" .. maybe_fg_color)
	else
		vim.cmd("highlight " .. group .. " guibg=NONE")
	end
end
-- make signcolumn have same bg as usual
if cfg.sign_column.flat then
	make_default_bg("SignColumn")
	make_default_bg("DiagnosticSignError")
	make_default_bg("DiagnosticSignWarn")
	make_default_bg("DiagnosticSignInfo")
	make_default_bg("DiagnosticSignHint")
	make_default_bg("DiagnosticSignOk")
end

if cfg.cursor_line then
	-- -- Show which line your cursor is on
	vim.o.cursorline = true
	make_default_bg("CursorLineNr")
	make_default_bg("CursorLine")
end
