vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank { higroup="Visual", timeout=150 }
	end
})

-- Set listchars to be hidden when using Neovim as a git difftool
vim.api.nvim_create_autocmd({"DiffUpdated", "BufRead"}, {
	callback = function()
		if vim.o.diff then
			vim.o.list = false
		else
			vim.o.list = true
		end
	end
})
