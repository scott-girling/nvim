local okay, _ = pcall(require, 'trouble')

if okay then
	require('trouble').setup()
	local s = vim.keymap.set

	s("n", "<leader>xx", "<cmd>Trouble diagnostics toggle focus=true<cr>")
	s("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=true<cr>")
	s("n", "<leader>cl", "<cmd>Trouble lsp toggle focus=true win.position=right<cr>")
end
