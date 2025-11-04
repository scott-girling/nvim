local okay, _ = pcall(require, 'trouble')

if okay then
	require('trouble').setup()
	local s = vim.keymap.set

	s("n", "<leader>dd", ":Trouble diagnostics toggle<cr>")
end
