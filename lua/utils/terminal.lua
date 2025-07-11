-- Store terminal buffer ID globally
local term_buf = nil
local term_win = nil

-- Function to toggle the terminal
local function toggle_terminal()
	-- If terminal window exists and is open, close it
	if term_win and vim.api.nvim_win_is_valid(term_win) then
		vim.api.nvim_win_close(term_win, true)
		term_win = nil
		return
	end

	-- If no terminal buffer exists, create a new one
	if not term_buf or not vim.api.nvim_buf_is_valid(term_buf) then
		-- Create a new terminal buffer
		term_buf = vim.api.nvim_create_buf(false, true) -- Not listed, scratch buffer
		vim.api.nvim_buf_set_option(term_buf, 'list', false) -- Disable list option for buffer
		vim.api.nvim_buf_call(term_buf, function()
			vim.fn.termopen(vim.o.shell) -- Open default shell
		end)
	end

	-- Create a new window for the terminal (horizontal split)
	vim.api.nvim_command('belowright split') -- Split below current window
	term_win = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(term_win, term_buf) -- Set terminal buffer in window
	vim.api.nvim_win_set_option(term_win, 'list', false) -- Disable list option for window
	vim.api.nvim_win_set_height(term_win, 20) -- Set height to 20 lines

	-- Start terminal in insert mode
	vim.api.nvim_command('startinsert')
end

-- Map <C-s> to toggle the terminal
vim.api.nvim_set_keymap('n', '<C-s>', '<cmd>lua require("utils.terminal").toggle_terminal()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<C-s>', '<C-\\><C-n><cmd>lua require("utils.terminal").toggle_terminal()<CR>', { noremap = true, silent = true })

-- Expose the toggle_terminal function
return {
	toggle_terminal = toggle_terminal
}
