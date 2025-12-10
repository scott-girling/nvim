local M = {
	"NeogitOrg/neogit",
	lazy = true,
	dependencies = {
		"nvim-lua/plenary.nvim",         -- required
		"sindrets/diffview.nvim",        -- optional - Diff integration
		"nvim-mini/mini.pick",           -- optional
	},
	cmd = "Neogit",
	opts = {
		graph_style ="unicode",
		kind = "tab",
		floating = {
			width = 0.9,
			height = 0.8,
		}
	},
	keys = {
		{ "<leader>gg", "<cmd>Neogit<cr>", desc = "Show Neogit UI" }
	}
}

return M
