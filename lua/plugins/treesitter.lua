local M = {
	"nvim-treesitter/nvim-treesitter",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-context", lazy = false
	},
	branch = 'master',
	lazy = false,
	build = ":TSUpdate",
	config = function ()
		require'nvim-treesitter.configs'.setup{
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
		}

		require'treesitter-context'.setup({
			enable = true
		})

		vim.keymap.set("n", "[c", function()
			require("treesitter-context").go_to_context(vim.v.count1)
		end, { silent = true })
	end,
}

return M
