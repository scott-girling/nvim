local M = {
	"NeogitOrg/neogit",
	lazy = true,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"sindrets/diffview.nvim",
		"folke/snacks.nvim",
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
