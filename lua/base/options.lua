-- Set some defaults that I prefer
local o = vim.opt

o.cursorline = true -- Highlight where the cursor is (line)
o.cuc = true -- Highlight where the cursor is (column)
o.expandtab = true -- Use spaces
o.formatoptions = "tcoqnj" -- :h 'formatoptions'
o.completeopt = "menuone,longest,popup,fuzzy" -- see 'completeopt'
o.conceallevel = 0 -- Why hide text in a text editor?
o.confirm = true -- Ask to save the buffer
o.ignorecase = true -- Case insensitive search patterns. Can be overruled with \c or \C in the pattern
o.smartcase = true -- Override the 'ignorecase' option if the search pattern contains upper case characters.
o.inccommand = "split" -- Show a partial off-screen preview with the search results
o.list = true -- Show non-text characters
o.listchars = {
	eol = "↲",
	tab = "󰌒 ",
	trail = "·",
	extends = "►",
	precedes = "◄",
	space = "·",
	nbsp = "␣",
}
o.mouse = "" -- Why use a mouse?
o.number = true -- Line numbers
o.relativenumber = true -- Relative line numbers
o.pumblend = 5 -- Transparent popups
o.pumheight = 10 -- Maximum number of items in a popup
o.pumwidth = 10 -- popup menu width
o.scrolloff = 3 -- Number of lines above and below the cursor when scrolling
o.shiftround = true -- Round indent to multiple of 'shiftwidth'.
o.shiftwidth = 4 -- The number of spaces when you tab
o.smartindent = true -- Do smart autoindenting when starting a new line
o.splitbelow = true -- Put new windows below
o.splitright = true -- Put new windows right
o.tabstop = 4 -- Not sure this is correct
o.timeoutlen = 400 -- Time to wait for a mapped sequence to complete
o.undofile = true -- When on, Vim automatically saves undo history to an undo file when writing a buffer to a file, and restores undo history from the same file on buffer read.
o.wrap = false -- Don't wrap lines
o.wildignorecase = true -- When set case is ignored when completing file names and directories.
o.wildmode = "longest:full,full" -- :h 'wildmode'
o.laststatus = 3

vim.g.netrw_banner = false -- Disable the netrw banner

vim.cmd.colorscheme "catppuccin-frappe"

-- Plugin specific options

-- Dadbod UI
vim.g.db_ui_use_nerd_fonts = 1
