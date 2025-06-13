local s = vim.keymap.set

vim.g.mapleader = " "

-- Basics
s("n", "<leader>w", "<cmd>w<cr>")
s("n", "<esc><esc>", "<cmd>nohls<cr>")
s("n", "<leader>m", "<cmd>make!<cr>")
s("n", "<leader>j", "gj")
s("n", "<leader>k", "gk")
s("n", "<leader>Q", "<cmd>qwa<cr>")

-- Navigation
-- s("n", "<leader>o", "<cmd>browse filt '".. vim.fn.getcwd() .."' old<cr>")
-- s("n", "<leader>O", "<cmd>browse filt! '.git/' old<cr>")
-- s("n", "<leader>e", ":e<space><c-r>=expand(\"%:h\")<cr>/")
s("n", "<leader>e", ":Neotree filesystem reveal<cr>")
s("n", "-", "<cmd>Neotree position=current reveal<cr>")

-- lgrep
s("n", "<leader>sw", "<cmd>silent<space>lgrep!<space><cword><cr><cmd>lopen<cr>")
s("n", "<leader>ss", ":silent lgrep<space>")
s("n", "<leader>sf", "<cmd>silent lgrep!<space>'function <cword>'<cr><cmd>lopen<cr>")

-- Buffers
s("n", "<leader><leader>", ":Neotree buffers reveal<cr>")
s("n", "[b", "<cmd>bp<cr>")
s("n", "]b", "<cmd>bp<cr>")
s("n", "<leader>bd", "<cmd>bd<cr>")

-- Quickfix
s("n", "<leader>q", "<cmd>copen<cr>")
s("n", "[q", "<cmd>cprev<cr>")
s("n", "]q", "<cmd>cnext<cr>")

-- Location list
s("n", "<leader>l", "<cmd>lopen<cr>")
s("n", "[l", "<cmd>lprev<cr>")
s("n", "]l", "<cmd>lnext<cr>")

-- Sessions (persistence)
-- s("n", "<leader>ps", "<cmd>mksession!<cr>")
-- s("n", "<leader>pl", "<cmd>source Session.vim<cr>")

-- Tabpages
s("n", "<leader>te", ":tabedit<space>")
s("n", "<leader>tn", "<cmd>tabnew<cr>")
s("n", "<leader>to", "<cmd>tabonly<cr>")
s("n", "<leader>tc", function()
	local path = vim.fn.input("Enter directory path: ", "", "dir")
	if path ~= "" then
		vim.cmd("tabnew")
		vim.cmd("tcd " .. path)
	end
end)

-- Netrw (disabled in favour of neotree)
-- s("n", "-", "<cmd>Explore<cr>")
-- s("n", "_", "<cmd>Vexplore<cr>")

-- Git
-- Function to set up syntax highlighting for git blame output
local function setup_gitblame_syntax()
	-- Clear any existing syntax to avoid conflicts
	vim.api.nvim_command("syntax clear")

	-- Define syntax matches for git blame components
	vim.api.nvim_command("syntax match GitBlameHash '^\\x\\{8,40\\}\\ze\\s'")
	vim.api.nvim_command("syntax match GitBlameAuthor '\\(\\x\\{8,40\\}\\s\\+\\)\\zs.\\{-}\\ze\\s\\+[0-9]\\{4\\}-'")
	vim.api.nvim_command("syntax match GitBlameDate '[0-9]\\{4\\}-[0-9]\\{2\\}-[0-9]\\{2\\}\\s[0-9]\\{2\\}:[0-9]\\{2\\}:[0-9]\\{2\\}\\s[+-][0-9]\\{4\\}'")
	vim.api.nvim_command("syntax match GitBlameSummary ')\\s.*$'")

	-- Define highlight groups with colors
	vim.api.nvim_command("highlight GitBlameHash guifg=#d08770 ctermfg=173")
	vim.api.nvim_command("highlight GitBlameAuthor guifg=#83a598 ctermfg=108")
	vim.api.nvim_command("highlight GitBlameDate guifg=#b8bb26 ctermfg=142")
	vim.api.nvim_command("highlight GitBlameSummary guifg=#8ec07c ctermfg=114")
end

function VisualGitBlame()
	-- Get the current buffer's file path
	local filepath = vim.api.nvim_buf_get_name(0)
	if filepath == "" then
		vim.notify("No file associated with this buffer", vim.log.levels.ERROR)
		return
	end

	-- Get the directory of the file
	local dir = vim.fn.fnamemodify(filepath, ":h")

	-- Check if the file is in a Git repository
	local git_cmd = "git -C " .. vim.fn.shellescape(dir) .. " rev-parse --is-inside-work-tree 2>/dev/null"
	local git_check = vim.fn.systemlist(git_cmd)
	local is_git_repo = vim.v.shell_error == 0 and #git_check > 0 and git_check[1] == "true"

	if not is_git_repo then
		vim.notify("Not in a Git repository", vim.log.levels.ERROR)
		return
	end

	-- Get the current mode
	local mode = vim.fn.mode()

	-- Get line range
	local line_start, line_end
	if mode == "v" or mode == "V" or mode == "" then
		-- In visual mode, get the start and end of the selection
		vim.cmd("normal! ") -- Exit visual mode to avoid state issues
		local start_pos = vim.fn.line("'<")
		local end_pos = vim.fn.line("'>")
		line_start = math.min(start_pos, end_pos)
		line_end = math.max(start_pos, end_pos)
	else
		-- In normal mode, use the current line only
		line_start = vim.fn.line(".")
		line_end = line_start
	end

	-- Construct and execute the git blame command
	local cmd = string.format("git blame -L%d,%d -- %s", line_start, line_end, vim.fn.shellescape(filepath))
	local blame_output = vim.fn.system(cmd)

	-- Check for errors in the git blame command
	if vim.v.shell_error ~= 0 then
		vim.notify("Git blame failed: " .. blame_output, vim.log.levels.ERROR)
		return
	end

	-- Delete existing "Git Blame" buffer if it exists and is valid
	local existing_buf = vim.fn.bufnr("Git Blame")
	if existing_buf ~= -1 and vim.api.nvim_buf_is_valid(existing_buf) then
		vim.api.nvim_buf_delete(existing_buf, { force = true })
	end

	-- Create a new buffer for the blame output
	local buf = vim.api.nvim_create_buf(false, true) -- Scratch buffer
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(blame_output, "\n"))

	-- Set buffer options for better display
	vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
	vim.api.nvim_buf_set_option(buf, "filetype", "gitblame")
	vim.api.nvim_buf_set_name(buf, "Git Blame")

	-- Add keybinding to close the buffer with 'q'
	vim.api.nvim_buf_set_keymap(buf, "n", "q", ":bdelete<CR>", { noremap = true, silent = true })

	-- Open the buffer in a new split
	vim.cmd("vsplit")
	local win = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(win, buf)

	-- Make the window read-only
	vim.api.nvim_win_set_option(win, "cursorline", true)
	vim.api.nvim_buf_set_option(buf, "readonly", true)

	-- Apply syntax highlighting
	vim.api.nvim_buf_call(buf, setup_gitblame_syntax)
end

-- Keymap for both normal and visual modes
vim.keymap.set({"n", "v"}, "<leader>gb", function()
	vim.cmd("lua VisualGitBlame()")
end, { noremap = true, silent = true })

-- Utilities
s("n", "<leader>cr", [[:execute 'read !'.getline('.')<CR>]]) -- "Command Run" execute the line the cursor is on and print the results to the buffer
