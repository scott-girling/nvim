local function has_executable(name)
	return vim.fn.executable(name) == 1
end

vim.lsp.config['luals'] = {
	cmd = { 'lua-language-server' },
	filetypes = { 'lua' },
	root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
	settings = {
		Lua = {
			runtime = {
				version = 'LuaJIT',
			}
		}
	}
}

vim.lsp.config['phpactor'] = {
	cmd = { 'phpactor', 'language-server' },
	filetypes = { 'php' },
	root_markers = { '.git', 'composer.json', '.phpactor.json', '.phpactor.yml' },
	workspace_required = true,
}

if has_executable('lua-language-server') then
	vim.lsp.enable('luals')
end

if has_executable('phpactor') then
	vim.lsp.enable('phpactor')
end
