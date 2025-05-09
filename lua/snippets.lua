-- Table to store snippets by filetype and global snippets
local snippets = {
	-- PHP snippets
	php = {
		["fn"] = "function ${1:name}(${2:params}) {\n\t${3:body}\n}",
		["if"] = "if (${1:condition}) {\n\t${2:body}\n}",
		["for"] = "for (${1:i} = ${2:0}; ${1:i} < ${3:count}; ${1:i}++) {\n\t${4:body}\n}",
	},
	-- Lua snippets
	lua = {
		["fn"] = "function ${1:name}(${2:params})\n\t${3:body}\nend",
		["if"] = "if ${1:condition} then\n\t${2:body}\nend",
		["for"] = "for ${1:i}=${2:1}, ${3:10} do\n\t${4:body}\nend",
	},
	-- Global snippets (available in all filetypes)
	global = {
		["todo"] = "TODO: ${1:task}",
		["note"] = "NOTE: ${1:comment}",
		["date"] = "${1:today} = os.date('%Y-%m-%d')",
	},
	-- Default snippets (for triggers not found in filetype or global)
	default = {
		["fn"] = "function ${1:name}(${2:params})\n\t${3:body}\nend",
		["if"] = "if ${1:condition} then\n\t${2:body}\nend",
	},
}

-- Function to count placeholders in a snippet
local function count_placeholders(snippet)
	local count = 0
	for _ in snippet:gmatch("%${%d+:.-}") do
		count = count + 1
	end
	return count
end

-- Variable to store the current snippet and its placeholder count
local current_snippet = nil
local placeholder_count = 0
local jump_count = 0

-- Function to check if the word before the cursor matches a snippet trigger
local function get_trigger_word()
	local line = vim.api.nvim_get_current_line()
	local col = vim.api.nvim_win_get_cursor(0)[2]
	local before_cursor = line:sub(1, col)
	local word = before_cursor:match("%w+$") or ""
	return word
end

-- Function to expand a snippet
local function expand_snippet()
	local trigger = get_trigger_word()
	local filetype = vim.bo.filetype
	-- Look for snippet in filetype-specific table, then global, then default
	local snippet = (snippets[filetype] and snippets[filetype][trigger])
	or snippets.global[trigger]
	or snippets.default[trigger]
	if snippet then
		-- Store the snippet and count its placeholders
		current_snippet = snippet
		placeholder_count = count_placeholders(snippet)
		jump_count = 0
		-- Delete the trigger word
		local line = vim.api.nvim_get_current_line()
		local col = vim.api.nvim_win_get_cursor(0)[2]
		local new_line = line:sub(1, col - #trigger) .. line:sub(col + 1)
		vim.api.nvim_set_current_line(new_line)
		-- Move cursor back to the correct position
		vim.api.nvim_win_set_cursor(0, { vim.api.nvim_win_get_cursor(0)[1], col - #trigger })
		-- Expand the snippet
		vim.snippet.expand(snippet)
	end
end

-- Function to navigate placeholders
local function jump(direction)
	if vim.snippet.active({ direction = direction }) then
		jump_count = jump_count + 1
		local prev_pos = vim.api.nvim_win_get_cursor(0)
		vim.snippet.jump(direction)
		local new_pos = vim.api.nvim_win_get_cursor(0)
		-- If the cursor didn't move or we've exceeded the placeholder count, stop the snippet
		if (prev_pos[1] == new_pos[1] and prev_pos[2] == new_pos[2]) or
			(placeholder_count <= 1) or
			(jump_count >= placeholder_count) then
			vim.snippet.stop()
			current_snippet = nil
			placeholder_count = 0
			jump_count = 0
			return false
		end
		return true
	end
	current_snippet = nil
	placeholder_count = 0
	jump_count = 0
	return false
end

-- Keymaps
vim.keymap.set({ "i", "s" }, "<C-e>", expand_snippet, { desc = "Expand snippet" })
vim.keymap.set({ "i", "s" }, "<Tab>", function()
	return jump(1) or vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
end, { desc = "Jump to next placeholder or insert tab" })
vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
	return jump(-1) or vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<S-Tab>", true, false, true), "n", false)
end, { desc = "Jump to previous placeholder or insert shift-tab" })
