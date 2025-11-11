local function browse_buffers()
	-----------------------------------------------------------------
	-- 1. Collect all tabpages and their *tabpage-local* cwd
	-----------------------------------------------------------------
	local tabpages = vim.api.nvim_list_tabpages()
	local tabinfo = {}   -- [tabpage] = { cwd = ..., buffers = {} }

	for _, tab in ipairs(tabpages) do
		-- Get tabpage-local cwd (Neovim 0.8+)
		local cwd = vim.fn.getcwd(-1, tab) or vim.fn.getcwd()
		tabinfo[tab] = { cwd = cwd, buffers = {} }
	end

	-----------------------------------------------------------------
	-- 2. Assign every listed buffer to a tabpage
	-----------------------------------------------------------------
	local buffers = vim.api.nvim_list_bufs()
	for _, buf in ipairs(buffers) do
		if vim.api.nvim_buf_is_loaded(buf)
		   and vim.api.nvim_buf_get_option(buf, "buflisted") then

			local name = vim.api.nvim_buf_get_name(buf)
			if name ~= "" then
				-- Find the tabpage that *displays* this buffer
				local found = false
				for _, tab in ipairs(tabpages) do
					local wins = vim.api.nvim_tabpage_list_wins(tab)
					for _, win in ipairs(wins) do
						if vim.api.nvim_win_get_buf(win) == buf then
							local dir = vim.fn.fnamemodify(name, ":h")
							table.insert(tabinfo[tab].buffers,
							              { buf = buf, name = name, dir = dir })
							found = true
							break
						end
					end
					if found then break end
				end

				-- Fallback: buffer not visible → put it in the current tabpage
				if not found then
					local cur_tab = vim.api.nvim_get_current_tabpage()
					local dir = vim.fn.fnamemodify(name, ":h")
					table.insert(tabinfo[cur_tab].buffers,
					              { buf = buf, name = name, dir = dir })
				end
			end
		end
	end

	-----------------------------------------------------------------
	-- 3. Build the tree: tabpage → directory → buffers
	-----------------------------------------------------------------
	local lines       = { "Buffers by Tabpage & Directory" }
	local all_buffers = {}   -- global index → entry
	local global_idx  = 1

	-- Keep tabpages in the order they appear in `:tabs`
	table.sort(tabpages, function(a, b) return a < b end)

	for _, tab in ipairs(tabpages) do
		local info = tabinfo[tab]
		if #info.buffers == 0 then goto continue end

		-- Tabpage header
		local tab_nr = vim.api.nvim_tabpage_get_number(tab)
		local cwd_display = vim.fn.fnamemodify(info.cwd, ":~")
		table.insert(lines, string.format("Tab %d %s", tab_nr, cwd_display))

		-- Group buffers by directory inside this tabpage
		local dir_map = {}
		for _, entry in ipairs(info.buffers) do
			dir_map[entry.dir] = dir_map[entry.dir] or {}
			table.insert(dir_map[entry.dir], entry)
		end

		-- Sort directories: cwd first, then alphabetical
		local dirs = vim.tbl_keys(dir_map)
		table.sort(dirs, function(a, b)
			local a_cwd = a == info.cwd
			local b_cwd = b == info.cwd
			if a_cwd ~= b_cwd then return a_cwd end
			return a < b
		end)

		for _, dir in ipairs(dirs) do
			local bufs = dir_map[dir]
			table.sort(bufs, function(a, b) return a.buf < b.buf end)

			-- Directory header
			local dir_display = (dir == info.cwd)
			                    and "(cwd) " .. vim.fn.fnamemodify(dir, ":t")
			                    or vim.fn.fnamemodify(dir, ":~")
			table.insert(lines, string.format("  Folder %s (%d)", dir_display, #bufs))

			-- Buffer entries
			for _, entry in ipairs(bufs) do
				local rel = vim.fn.fnamemodify(entry.name, ":.")
				local cur = vim.api.nvim_get_current_buf() == entry.buf and "%" or " "
				local mod = vim.api.nvim_buf_get_option(entry.buf, "modified") and "+" or " "
				table.insert(lines,
				             string.format("    %d: %s %s%s", global_idx, rel, cur, mod))
				all_buffers[global_idx] = entry
				global_idx = global_idx + 1
			end
		end

		::continue::
	end

	if global_idx == 1 then
		vim.notify("No listed buffers found.", vim.log.levels.WARN)
		return
	end

	-----------------------------------------------------------------
	-- 4. Scratch buffer & display
	-----------------------------------------------------------------
	local list_buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(list_buf, 0, -1, false, lines)
	vim.api.nvim_buf_set_option(list_buf, "buftype", "nofile")
	vim.api.nvim_buf_set_option(list_buf, "modifiable", false)
	vim.api.nvim_buf_set_name(list_buf, "buffers-tree")
	vim.api.nvim_buf_set_option(list_buf, "bufhidden", "wipe")

	-- Highlighting
	vim.api.nvim_buf_add_highlight(list_buf, -1, "Title", 0, 0, -1)
	for i = 2, #lines do
		local line = i - 1
		local txt  = lines[i]
		if txt:match("^Tab %d+") then
			vim.api.nvim_buf_add_highlight(list_buf, -1, "Directory", line, 0, -1)
		elseif txt:match("^  Folder") then
			vim.api.nvim_buf_add_highlight(list_buf, -1, "Comment", line, 0, -1)
		elseif txt:match("^    %d+:") then
			vim.api.nvim_buf_add_highlight(list_buf, -1, "Number", line, 4, 7)
			local col = 7 + #tostring(#all_buffers) + 1
			vim.api.nvim_buf_add_highlight(list_buf, -1, "Special", line, col, col + 1)
		end
	end

	-- Open in vertical split
	local ok, err = pcall(vim.cmd, "vsplit")
	if not ok then
		vim.notify("Failed to vsplit: " .. err, vim.log.levels.ERROR)
		pcall(vim.api.nvim_buf_delete, list_buf, { force = true })
		return
	end
	local list_win = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(list_win, list_buf)
	vim.api.nvim_win_set_cursor(list_win, { 2, 0 })

	-----------------------------------------------------------------
	-- 5. Helpers & keymaps
	-----------------------------------------------------------------
	local function close_list()
		pcall(vim.api.nvim_win_close, list_win, true)
		if vim.api.nvim_buf_is_valid(list_buf) then
			pcall(vim.api.nvim_buf_delete, list_buf, { force = true })
		end
	end

	local function switch_to_buffer(open_cmd)
		local line = vim.api.nvim_get_current_line()
		local idx  = tonumber(line:match("(%d+):"))
		if idx and all_buffers[idx] then
			local target = all_buffers[idx].buf
			close_list()
			if open_cmd == "edit" then
				vim.api.nvim_set_current_buf(target)
			else
				pcall(vim.cmd, open_cmd .. " +buffer" .. target)
			end
		end
	end

	local opts = { buffer = list_buf, noremap = true, silent = true }
	vim.keymap.set("n", "<CR>", function() switch_to_buffer("edit")    end, opts)
	vim.keymap.set("n", "s",    function() switch_to_buffer("split")   end, opts)
	vim.keymap.set("n", "v",    function() switch_to_buffer("vsplit")  end, opts)
	vim.keymap.set("n", "t",    function() switch_to_buffer("tabedit") end, opts)
	vim.keymap.set("n", "q",    close_list, opts)
end

-- Trigger
vim.keymap.set("n", "<leader><leader>",
               browse_buffers,
               { desc = "Browse buffers by tabpage pwd → directory tree" })
