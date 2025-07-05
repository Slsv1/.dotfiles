return {
    cmd={'lua-language-server'},
    filetypes={'lua'},
    root_markers={'.luarc.json', '.luarc.jsonc', '.git'},
    settings={
      Lua={
        runtime = {
        path = { "?.lua", "?/init.lua" },
        pathStrict = true,
        version = "LuaJIT"
      },
      workspace = {
        checkThirdParty = false,
        ignoreDir = { "/lua" },
        library = { "/snap/nvim/3953/usr/share/nvim/runtime/lua", "/home/slava/.config/nvim/lua", "${3rd}/luv/library", "/home/slava/.local/share/nvim/lazy/lazy.nvim/lua", "/home/slava/.local/share/nvim/lazy/gitsigns.nvim/lua", "/home/slava/.local/share/nvim/lazy/telescope.nvim/lua", "/home/slava/.local/share/nvim/lazy/mason.nvim/lua", "/home/slava/.local/share/nvim/lazy/blink.cmp/lua", "/home/slava/.local/share/nvim/lazy/mason-tool-installer.nvim/lua", "/home/slava/.local/share/nvim/lazy/mason-lspconfig.nvim/lua", "/home/slava/.local/share/nvim/lazy/nvim-lspconfig/lua", "/home/slava/.local/share/nvim/lazy/conform.nvim/lua", "/home/slava/.local/share/nvim/lazy/LuaSnip/lua", "/home/slava/.local/share/nvim/lazy/tokyonight.nvim/lua", "/home/slava/.local/share/nvim/lazy/mini.nvim/lua" }
      }                    	}
    },
    single_file_support = true
}
