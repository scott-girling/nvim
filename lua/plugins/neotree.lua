local okay, _ = pcall(require, 'neo-tree')

if okay then
	local s = vim.keymap.set

	s("n", "<leader>e", ":Neotree filesystem reveal<cr>")
	s("n", "-", "<cmd>Neotree position=current reveal<cr>")
	s("n", "<leader><leader>", ":Neotree buffers reveal<cr>")
end
