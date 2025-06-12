-- Define a function to show and filter oldfiles
local function browse_oldfiles(filter_dir, exclude_git)
	-- Get the oldfiles list
	local oldfiles = vim.v.oldfiles
	if not oldfiles or #oldfiles == 0 then
		vim.notify("No old files found.", vim.log.levels.WARN)
		return
	end

	-- Get current working directory if filter_dir is not provided
	filter_dir = filter_dir or vim.fn.getcwd()
	local is_cwd = filter_dir == vim.fn.getcwd()

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
		vim.notify("No files match the criteria.", vim.log.levels.WARN)
		return
	end

	-- Create a formatted list with a heading and sequential indices
	local title = is_cwd and "Oldfiles (cwd)" or "Oldfiles (all)"
	local lines = { title } -- Heading
	for i, file in ipairs(filtered) do
		-- Show relative path for brevity
		local display_path = vim.fn.fnamemodify(file, ":.")
		table.insert(lines, string.format("%d: %s", i, display_path))
	end

	-- Create a new buffer to display the list
	local buf = vim.api.nvim_create_buf(false, true) -- Scratch buffer
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.api.nvim_buf_set_option(buf, "buftype", "prompt")
	vim.api.nvim_buf_set_option(buf, "modifiable", false)

	-- Apply syntax highlighting for the heading
	vim.api.nvim_buf_add_highlight(buf, -1, "Title", 0, 0, 8) -- "Oldfiles"
	vim.api.nvim_buf_add_highlight(buf, -1, "Special", 0, 8, -1) -- "(cwd)" or "(all)"

	-- Open a new vertical split to display the buffer
	local ok, err = pcall(vim.cmd, "vsplit")
	if not ok then
		vim.notify("Failed to open vsplit: " .. err, vim.log.levels.ERROR)
		vim.api.nvim_buf_delete(buf, { force = true })
		return
	end
	local win = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(win, buf)

	-- Move cursor to the first file entry (line 2, since line 1 is the heading)
	vim.api.nvim_win_set_cursor(win, {2, 0})

	-- Function to handle file opening
	local function open_file(open_cmd)
		local line = vim.api.nvim_get_current_line()
		local index = tonumber(line:match("^(%d+):"))
		if index and filtered[index] then
			local selected_file = filtered[index]
			vim.api.nvim_win_close(win, true) -- Close the window
			vim.api.nvim_buf_delete(buf, { force = true }) -- Delete the buffer
			local cmd_ok, cmd_err = pcall(vim.cmd, open_cmd .. " " .. vim.fn.fnameescape(selected_file))
			if not cmd_ok then
				vim.notify("Failed to open file: " .. cmd_err, vim.log.levels.ERROR)
			end
		end
	end

	-- Set keymaps for different opening methods
	vim.keymap.set("n", "<CR>", function() open_file("edit") end, { buffer = buf, noremap = true, silent = true })
	vim.keymap.set("n", "s", function() open_file("split") end, { buffer = buf, noremap = true, silent = true })
	vim.keymap.set("n", "v", function() open_file("vsplit") end, { buffer = buf, noremap = true, silent = true })
	vim.keymap.set("n", "t", function() open_file("tabedit") end, { buffer = buf, noremap = true, silent = true })
	vim.keymap.set("n", "q", function()
		vim.api.nvim_win_close(win, true)
		vim.api.nvim_buf_delete(buf, { force = true })
	end, { buffer = buf, noremap = true, silent = true })
end

-- Set keymaps to call the function with different options
vim.keymap.set("n", "<leader>o", function()
	browse_oldfiles(vim.fn.getcwd(), false)
end, { desc = "Browse oldfiles in cwd" })

vim.keymap.set("n", "<leader>O", function()
	browse_oldfiles(nil, true)
end, { desc = "Browse oldfiles, exclude .git/" })
