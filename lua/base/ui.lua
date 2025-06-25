-- Configuration: Toggle features on or off
local show_modification_status = true
local show_buffer_count = true

-- Abbreviate relative path (first letter of dirs, full filename)
local function abbreviate_relative(rel_path)
	if rel_path == '' then return '' end
	local parts = vim.split(rel_path, '/')
	local abbreviated = {}
	for i = 1, #parts - 1 do
		table.insert(abbreviated, string.sub(parts[i], 1, 1))
	end
	if #parts > 0 then
		table.insert(abbreviated, parts[#parts])
	end
	return table.concat(abbreviated, '/')
end

-- Function to set tab-specific CWD
local function set_tab_cwd()
	local tabnr = vim.fn.tabpagenr()
	local cwd = vim.fn.getcwd()
	vim.fn.settabvar(tabnr, 'cwd', cwd)
end

-- Custom tabline function
function _G.my_tabline()
	local parts = {}
	local total_tabs = vim.fn.tabpagenr('$')
	local current_tab = vim.fn.tabpagenr()
	for i = 1, total_tabs do
		local tabnr = i
		-- Get the tab-specific CWD or fall back to global CWD
		local cwd = vim.fn.gettabvar(tabnr, 'cwd', '')
		if cwd == '' then
			cwd = vim.fn.getcwd()
			-- Set the cwd for this tab to avoid future fallbacks
			vim.fn.settabvar(tabnr, 'cwd', cwd)
		end
		-- Ensure cwd is always a valid directory path
		if cwd == '' then
			cwd = '/' -- Fallback to root if cwd is somehow invalid
		end
		local abbreviated_cwd = vim.fn.pathshorten(cwd)
		-- Get the current window and buffer for this tab
		local winid = vim.api.nvim_tabpage_get_win(tabnr)
		local bufnr = vim.api.nvim_win_get_buf(winid)
		local file_path = vim.api.nvim_buf_get_name(bufnr)
		-- Compute the relative path by removing the CWD prefix
		local relative_path = ''
		if file_path ~= '' and string.sub(file_path, 1, #cwd) == cwd and string.sub(file_path, #cwd + 1, #cwd + 1) == '/' then
			relative_path = string.sub(file_path, #cwd + 2)
		elseif file_path ~= '' then
			-- If file_path is outside cwd, use the full path as relative for context
			relative_path = file_path
		end
		local abbreviated_relative = abbreviate_relative(relative_path)
		-- Base label: "tab_number - abbreviated_cwd - path"
		local label = string.format("%d - %s - %s", tabnr, abbreviated_cwd, abbreviated_relative ~= '' and abbreviated_relative or '[No Name]')

		-- Add modification status if enabled
		if show_modification_status and vim.api.nvim_buf_get_option(bufnr, 'modified') then
			label = label .. ' *'
		end

		-- Add buffer count if enabled
		if show_buffer_count then
			local buf_count = #vim.fn.tabpagebuflist(tabnr)
			label = label .. ' [' .. buf_count .. ']'
		end

		local hl = (i == current_tab) and '%#TabLineSel#' or '%#TabLine#'
		local clickable = '%' .. tabnr .. 'T'
		table.insert(parts, hl .. clickable .. ' ' .. label .. ' ')
	end
	table.insert(parts, '%#TabLineFill#')
	return table.concat(parts, '')
end

-- Apply the tabline
vim.o.tabline = '%!v:lua.my_tabline()'

-- Autocommand to update tab-specific CWD when it changes
vim.api.nvim_create_autocmd({"DirChanged"}, {
	callback = function()
		set_tab_cwd()
	end,
})

-- Initialize CWD for existing tabs when this script loads
for i = 1, vim.fn.tabpagenr('$') do
	vim.fn.settabvar(i, 'cwd', vim.fn.getcwd())
end
