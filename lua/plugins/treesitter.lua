local M = {
	"nvim-treesitter/nvim-treesitter",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-context"
	},
	branch = 'master',
	lazy = false,
	build = ":TSUpdate",
	opt = function ()
		require'treesitter-context'.setup({
			enable = true
		})

		vim.keymap.set("n", "[c", function()
			require("treesitter-context").go_to_context(vim.v.count1)
		end, { silent = true })

		return {
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
	end
}

return M
