local okay, _ = pcall(require, 'blink.cmp')

if okay then
	require("blink.cmp").setup({
		keymap = { preset = 'default' },
		appearance = {
			nerd_font_variant = 'mono'
		},
		completion = { documentation = { auto_show = false } },
		sources = {
			default = { 'lsp', 'buffer', 'snippets', 'path' },
			per_filetype = {
				sql = { 'dadbod' },
			},
			providers = {
				dadbod = { module = "vim_dadbod_completion.blink" },
			},
		},
		fuzzy = { implementation = "prefer_rust_with_warning", prebuilt_binaries = { force_version = "v1.7.0" } }
	})
end
