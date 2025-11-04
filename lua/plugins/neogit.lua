local okay, _ = pcall(require, 'neogit')

if okay then
	local s = vim.keymap.set

	s("n", "<leader>gg", ":Neogit<cr>")
end
