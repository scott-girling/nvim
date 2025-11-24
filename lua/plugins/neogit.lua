local okay, _ = pcall(require, 'neogit')

if okay then
	local s = vim.keymap.set
	local neogit = require 'neogit'

	neogit.setup {
		graph_style ="unicode",
		kind = "tab",
		floating = {
			width = 0.9,
			height = 0.8,
		}
	}

	s("n", "<leader>gg", ":Neogit<cr>")
end
