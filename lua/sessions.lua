-- Session Management
local session_dir = vim.fn.expand("~/.local/share/nvim/sessions")

-- Create sessions directory if it doesn't exist
if vim.fn.isdirectory(session_dir) == 0 then
	vim.fn.mkdir(session_dir, "p")
end

-- Get session file path (use current directory name as session name)
local function get_session_file()
	local dir_name = vim.fn.substitute(vim.fn.getcwd(), "[^A-Za-z0-9]", "_", "g")
	return session_dir .. "/" .. dir_name .. ".vim"
end

-- Save session
local function save_session()
	local session_file = get_session_file()
	vim.cmd("mksession! " .. session_file)
	vim.notify("Session saved to " .. session_file, vim.log.levels.INFO)
end

-- Load session
local function load_session()
	local session_file = get_session_file()
	if vim.fn.filereadable(session_file) == 1 then
		vim.cmd("source " .. session_file)
		vim.notify("Session loaded from " .. session_file, vim.log.levels.INFO)
	else
		vim.notify("No session file found for this directory", vim.log.levels.WARN)
	end
end

-- Delete session
local function delete_session()
	local session_file = get_session_file()
	if vim.fn.filereadable(session_file) == 1 then
		vim.fn.delete(session_file)
		vim.notify("Session deleted: " .. session_file, vim.log.levels.INFO)
	else
		vim.notify("No session file found to delete", vim.log.levels.WARN)
	end
end

-- Key mappings
vim.keymap.set("n", "<leader>ps", save_session, { desc = "Save session" })
vim.keymap.set("n", "<leader>pl", load_session, { desc = "Load session" })
vim.keymap.set("n", "<leader>pd", delete_session, { desc = "Delete session" })
