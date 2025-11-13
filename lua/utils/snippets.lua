-- snippets.lua
-- Improved custom snippet system using Neovim's built-in vim.snippet API

local snippets = {
	-- PHP snippets
	php = {
		["fn"] = "function ${1:name}(${2:params}) {\n\t${3:body}\n}",
		["if"] = "if (${1:condition}) {\n\t${2:body}\n}",
		["for"] = "for (${1:i} = ${2:0}; ${1:i} < ${3:count}; ${1:i}++) {\n\t${4:body}\n}",
		["vd"] = "var_dump(${1:__LINE__}); die;$0"
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
	-- Default fallback snippets
	default = {
		["fn"] = "function ${1:name}(${2:params})\n\t${3:body}\nend",
		["if"] = "if ${1:condition} then\n\t${2:body}\nend",
	},
}

-- Safely get the word before cursor, only if followed by non-word char or EOL
local function get_trigger_word()
	local line = vim.api.nvim_get_current_line()
	local col = vim.api.nvim_win_get_cursor(0)[2]
	local before_cursor = line:sub(1, col)
	local word = before_cursor:match("(%w+)[^%w]*$")
	return word or ""
end

-- Expand snippet by replacing trigger and calling vim.snippet.expand
local function expand_snippet()
	local trigger = get_trigger_word()
	if #trigger == 0 then return end

	local ft = vim.bo.filetype
	local snippet = snippets[ft] and snippets[ft][trigger]
	or snippets.global[trigger]
	or snippets.default[trigger]
	if not snippet then return end

	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local start_col = col - #trigger + 1

	-- Replace trigger with empty string
	vim.api.nvim_buf_set_text(0, row - 1, start_col - 1, row - 1, col, {""})
	-- Move cursor to insertion point
	vim.api.nvim_win_set_cursor(0, {row, start_col - 1})

	-- Schedule expansion to ensure cursor is in place
	vim.schedule(function()
		vim.snippet.expand(snippet)
	end)
end

-- Jump to next/previous placeholder if snippet is active
local function try_jump(direction)
	if vim.snippet.active({ direction = direction }) then
		vim.snippet.jump(direction)
		return true
	else
		return false
	end
end

-- Keymaps
vim.keymap.set({ "i", "s" }, "<C-e>", expand_snippet, { desc = "Expand snippet" })

vim.keymap.set({ "i", "s" }, "<Tab>", function()
	if not try_jump(1) then
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
	end
end, { desc = "Jump to next placeholder or insert Tab" })

vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
	if not try_jump(-1) then
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<S-Tab>", true, false, true), "n", false)
	end
end, { desc = "Jump to previous placeholder or insert Shift-Tab" })
