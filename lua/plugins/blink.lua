local M = {}

M = {
	'saghen/blink.cmp',
	dependencies = { 'rafamadriz/friendly-snippets' },
	version = '1.*',

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		keymap = { preset = 'default' },

		sources = {
			default = { 'lsp', 'path', 'snippets', 'buffer' },
		},
	},
	opts_extend = { "sources.default" }
}

return M
