local M = {
"lewis6991/gitsigns.nvim"
}

local okay, _ = pcall(require, 'gitsigns')

if okay then
	local s = vim.keymap.set

	s("n", "<leader>gb", "<cmd>Gitsigns blame<cr>")
end

return M
