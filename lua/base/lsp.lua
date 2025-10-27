local function has_executable(name)
	return vim.fn.executable(name) == 1
end

--- Base capabilities with folding support
local base_capabilities = {
	textDocument = {
		foldingRange = {
			dynamicRegistration = false,
			lineFoldingOnly = true
		}
	}
}

--- Enhanced capabilities with blink.cmp integration
local capabilities = base_capabilities
local blink_ok, blink = pcall(require, 'blink.cmp')
if blink_ok then
	capabilities = blink.get_lsp_capabilities(base_capabilities)
end

--- Global LSP configuration
vim.lsp.config('*', {
	capabilities = capabilities,
	root_markers = { '.git' },
})

--- Language server configurations
local servers = {
	luals = {
		cmd = { 'lua-language-server' },
		filetypes = { 'lua' },
		root_markers = { { '.luarc.json', '.luarc.jsonc' } },
		settings = {
			Lua = {
				runtime = {
					version = 'LuaJIT',
				},
				diagnostics = {
					globals = { 'vim' }, -- Recognize 'vim' global for Neovim configs
				},
				workspace = {
					library = vim.api.nvim_get_runtime_file('', true),
					checkThirdParty = false,
				},
				telemetry = {
					enable = false,
				},
				completion = {
					callSnippet = 'Replace',
				},
			}
		}
	},

	phpactor = {
		cmd = { 'phpactor', 'language-server' },
		filetypes = { 'php' },
		root_markers = { 'composer.json', '.phpactor.json', '.phpactor.yml' },
		workspace_required = true,
	},

	nixd = {
		cmd = { 'nixd' },
		filetypes = { 'nix' },
		root_markers = { 'flake.nix', '.git' },
	},
}

--- Function to configure and enable a language server
---@param server_name string The name of the server
---@param config table The server configuration
local function setup_server(server_name, config)
	-- Configure the server
	vim.lsp.config[server_name] = config

	-- Check if the server executable is available
	if config.cmd and has_executable(config.cmd[1]) then
		vim.lsp.enable(server_name)
	end
end

--- Setup all configured servers
for server_name, config in pairs(servers) do
	setup_server(server_name, config)
end
