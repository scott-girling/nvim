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

-- lgrep
s("n", "<leader>sw", "<cmd>silent<space>lgrep!<space><cword><cr><cmd>lopen<cr>")
s("n", "<leader>ss", ":silent lgrep<space>")
s("n", "<leader>sf", "<cmd>silent lgrep!<space>'function <cword>'<cr><cmd>lopen<cr>")

-- Buffers
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

-- Utilities
s("n", "<leader>cr", [[:execute 'read !'.getline('.')<CR>]]) -- "Command Run" execute the line the cursor is on and print the results to the buffer
