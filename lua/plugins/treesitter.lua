local okay, treesitter = pcall(require, 'nvim-treesitter.configs')

if okay then
	treesitter.setup({
		ensure_installed = {
			"c",
			"lua",
			"vim",
			"vimdoc",
			"query",
			"markdown",
			"markdown_inline",
			"php",
			"javascript",
			"html",
			"json",
		},

		highlight = {
			enable = true,
		},
	})
end
