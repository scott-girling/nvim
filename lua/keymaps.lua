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
s("n", "<leader><leader>", "<cmd>ls<cr>:b<space>")
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
s("n", "<leader>ps", "<cmd>mksession!<cr>")
s("n", "<leader>pl", "<cmd>source Session.vim<cr>")

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

-- Netrw (disabled in favour of Oil.nvim)
-- s("n", "-", "<cmd>Explore<cr>")
-- s("n", "_", "<cmd>Vexplore<cr>")

-- Git
function VisualGitBlame()
	local start_pos = vim.fn.line("v")
	local end_pos = vim.fn.line(".")

	local cmd = string.format("execute \"!git blame -L%d,%d -- %s\"", start_pos, end_pos, vim.api.nvim_buf_get_name(0))

	vim.cmd(cmd)
end

s({"n", "v"}, "<leader>gb", "<cmd>lua VisualGitBlame()<cr>")

-- Utilities
s("n", "<leader>cr", [[:execute 'read !'.getline('.')<CR>]]) -- "Command Run" execute the line the cursor is on and print the results to the buffer

-- Better oldfiles
-- Define a function to show and filter oldfiles
local function browse_oldfiles(filter_dir, exclude_git)
	-- Get the oldfiles list
	local oldfiles = vim.v.oldfiles
	if not oldfiles or #oldfiles == 0 then
		print("No old files found.")
		return
	end

	-- Get current working directory if filter_dir is not provided
	filter_dir = filter_dir or vim.fn.getcwd()

	-- Filter oldfiles
	local filtered = {}
	for _, file in ipairs(oldfiles) do
		-- Check if file exists and matches the filter criteria
		if vim.fn.filereadable(file) == 1 then
			local include = true
			-- Filter by directory (starts with filter_dir)
			if filter_dir then
				include = include and vim.startswith(file, filter_dir)
			end
			-- Exclude .git directory if specified
			if exclude_git then
				include = include and not file:match("%.git/")
			end
			if include then
				table.insert(filtered, file)
			end
		end
	end

	if #filtered == 0 then
		print("No files match the criteria.")
		return
	end

	-- Create a formatted list with sequential indices
	local lines = {}
	for i, file in ipairs(filtered) do
		-- Show relative path for brevity, or full path if preferred
		local display_path = vim.fn.fnamemodify(file, ":.")
		table.insert(lines, string.format("%d: %s", i, display_path))
	end

	-- Create a new buffer to display the list
	local buf = vim.api.nvim_create_buf(false, true) -- Scratch buffer
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.api.nvim_buf_set_option(buf, "buftype", "prompt")
	vim.api.nvim_buf_set_option(buf, "modifiable", false)

	-- Open a new window to display the buffer
	vim.cmd("vsplit") -- Vertical split; use "split" for horizontal
	local win = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(win, buf)

	-- Set keymap to open selected file and delete buffer
	vim.api.nvim_buf_set_keymap(buf, "n", "<CR>", "", {
		callback = function()
			local line = vim.api.nvim_get_current_line()
			local index = tonumber(line:match("^(%d+):"))
			if index and filtered[index] then
				local selected_file = filtered[index]
				vim.api.nvim_win_close(win, true) -- Close the window
				vim.api.nvim_buf_delete(buf, { force = true }) -- Delete the buffer
				vim.cmd("edit " .. vim.fn.fnameescape(selected_file)) -- Open the file
			end
		end,
		noremap = true,
		silent = true,
	})

	-- Set keymap to quit
	vim.api.nvim_buf_set_keymap(buf, "n", "q", "", {
		callback = function()
			vim.api.nvim_win_close(win, true)
			vim.api.nvim_buf_delete(buf, { force = true }) -- Delete the buffer on quit
		end,
		noremap = true,
		silent = true,
	})
end

-- Set keymaps to call the function
s("n", "<leader>o", function()
	browse_oldfiles(vim.fn.getcwd(), false)
end, { desc = "Browse oldfiles in cwd" })

s("n", "<leader>O", function()
	browse_oldfiles(nil, true)
end, { desc = "Browse oldfiles, exclude .git/" })
