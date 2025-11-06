local M = {}

M.colorscheme_name = "scott"

M.colors = {
	fg = "#d2d1ce",
	bg = "#283740",
	bg_brighter = "#5d8094",

	black = "#1a1d23",
	black_bright = "#455a64",

	red = "#e67e73",
	red_bright = "#ff99cc",
	red_hard = "#ef7882",

	green = "#bcf17e",
	green_bright = "#a0eb49",
	green_greyish = "#7a9485",
	lime_green = "#46e5b3",

	yellow = "#f7dc6f",
	yellow_bright = "#ffff99",
	yellow_pale = "#F2E08D",

	orange = "#ffd280",
	dark_orange = "#ffad6e",

	blue = "#66d9ef",
	blue_bright = "#87cefa",
	blue_mid_grey = "#3B4551",
	blue_midnight = "#3e5563",

	magenta = "#c7b8ea",
	magenta_bright = "#dfd6f3",
	magenta_sharp = "#ff85f4",
	magenta_dim = "#af9ae1",

	cyan = "#46c8e5",
	cyan_bright = "#4fdfff",

	white = "#d2d1ce",
	white_bright = "#d2d1ce",

	grey_dark_mid = "#666666",
	grey_slate = "#626a73",
	grey_charcoal = "#3b4551",
}

M.highlights = {
	Comment = { fg = M.colors.green_greyish, italic = true },
	CursorColumn = { link = "CursorLine" },
	CursorLine = { bg = M.colors.blue_mid_grey },
	Delimiter = { fg = M.colors.red_hard },
	Function = { fg = M.colors.cyan },
	Statement = { fg = M.colors.yellow },
	Normal = { fg = M.colors.fg, bg = M.colors.bg },
	String = { fg = M.colors.green },
	Operator = { fg = M.colors.magenta_dim },
	LineNr = { fg = M.colors.grey_dark_mid },
	NonText = { fg = M.colors.blue_midnight },
	CurSearch = { bg = M.colors.yellow, fg = M.colors.black },
	Search = { bg = M.colors.bg_brighter, fg = M.colors.black, bold = true },
	TabLineSel = { bg = M.colors.magenta, fg = M.colors.black, bold = true },
	TabLine = { fg = M.colors.bg_brighter, italic = true },
	Constant = { fg = M.colors.red, bold = true },
	Visual = { bg = M.colors.yellow, fg = M.colors.black },
	StatusLine = { bg = M.colors.green, fg = M.colors.black, bold = true },
	StatusLineNC = { bg = M.colors.blue_mid_grey, fg = M.colors.grey_slate },
	WinSeparator = { fg = M.colors.grey_slate, bg = M.colors.grey_charcoal },
	PmenuSel = { bg = M.colors.green, fg = M.colors.black, bold = true },
	DiffAdd = { bg = M.colors.green, fg = M.colors.black, bold = true },
	DiffDelete = { bg = M.colors.red, fg = M.colors.black, bold = true },
	DiffChange = { bg = M.colors.yellow, fg = M.colors.black, bold = true },
	DiffText = { bg = M.colors.magenta, fg = M.colors.black, bold = true },
	diffAdded = { fg = M.colors.green },
	diffRemoved = { fg = M.colors.red },
	diffChanged = { fg = M.colors.yellow },
	Directory = { fg = M.colors.cyan },
	qfFileName =  { fg = M.colors.green_greyish },
	qfLineNr = { fg = M.colors.magenta },
	QuickFixLine = { fg = M.colors.green },
	Error = { bg = M.colors.red, bold = true, fg = M.colors.black },
	Special = { fg = M.colors.lime_green, italic = true },
	Type = { fg = M.colors.magenta },
	Number = { fg = M.colors.red_bright },
	WildMenu = { bg = M.colors.magenta, fg = M.colors.black, bold = true },
	TaskHL = { fg = M.colors.magenta, bold = true },
	DoneHL = { fg = M.colors.green, bold = true },
	ActiveHL = { fg = M.colors.orange, bold = true },
	["@number"] = { fg = M.colors.red_bright },
	["@number.float"] = { link = "@number" },
	["@boolean.php"] = { fg = M.colors.cyan },
	["@keyword.return.php"] = { fg = M.colors.dark_orange },
	["@keyword.modifier.php"] = { fg = M.colors.yellow_pale, italic = true },
	["@type.php"] = { fg = M.colors.magenta_dim, italic = true },
	["@variable.member.php"] = { link = "@property.php" },
	["@markup.heading.2.markdown"] = { fg = M.colors.green },
	["@markup.heading.3.markdown"] = { fg = M.colors.orange },

	-- Neogit Integration
	NeogitBranch = { fg = M.colors.magenta, bold = true },
	NeogitRemote = { fg = M.colors.cyan, bold = true },
	NeogitHunkHeader = { fg = M.colors.blue_bright, bg = M.colors.blue_mid_grey },
	NeogitHunkHeaderHighlight = { fg = M.colors.blue, bg = M.colors.blue_midnight, bold = true },
	NeogitDiffContext = { fg = M.colors.fg, bg = M.colors.bg },
	NeogitDiffContextHighlight = { fg = M.colors.white, bg = M.colors.blue_mid_grey },
	NeogitDiffAdd = { fg = M.colors.green, bg = M.colors.black },
	NeogitDiffAddHighlight = { fg = M.colors.green_bright, bg = M.colors.black, bold = true },
	NeogitDiffDelete = { fg = M.colors.red, bg = M.colors.black },
	NeogitDiffDeleteHighlight = { fg = M.colors.red_bright, bg = M.colors.black, bold = true },

	-- Commit & Log View
	NeogitCommitViewHeader = { fg = M.colors.yellow, bold = true },
	NeogitCommitViewDescription = { fg = M.colors.fg },
	NeogitCommitViewAuthor = { fg = M.colors.orange, italic = true },
	NeogitCommitViewDate = { fg = M.colors.green_greyish },

	-- Popup & Status
	NeogitPopupSectionTitle = { fg = M.colors.cyan, bold = true },
	NeogitPopupBranchName = { fg = M.colors.magenta },
	NeogitPopupConfig = { fg = M.colors.yellow_pale },
	NeogitPopupSwitchKey = { fg = M.colors.red_hard },
	NeogitPopupSwitchEnabled = { fg = M.colors.green },
	NeogitPopupSwitchDisabled = { fg = M.colors.grey_dark_mid },
	NeogitPopupOptionKey = { fg = M.colors.orange },
	NeogitPopupOptionEnabled = { fg = M.colors.green },
	NeogitPopupOptionDisabled = { fg = M.colors.grey_dark_mid },

	-- Notification / Cursor
	NeogitNotificationInfo = { fg = M.colors.blue },
	NeogitNotificationWarning = { fg = M.colors.yellow },
	NeogitNotificationError = { fg = M.colors.red, bold = true },

	-- Cursor in Neogit buffers
	NeogitCursorLine = { bg = M.colors.blue_mid_grey },

	-- File names in status
	NeogitFilePath = { fg = M.colors.cyan, italic = true },

	-- Staged/Unstaged indicators
	NeogitStagedChanges = { fg = M.colors.green, bold = true },
	NeogitUnstagedChanges = { fg = M.colors.orange, bold = true },
	NeogitUntrackedFiles = { fg = M.colors.magenta_dim, italic = true },

	-- Graph colors (if using unicode/kitty style)
	NeogitGraphAuthor = { fg = M.colors.orange },
	NeogitGraphRed = { fg = M.colors.red },
	NeogitGraphGreen = { fg = M.colors.green },
	NeogitGraphYellow = { fg = M.colors.yellow },
	NeogitGraphBlue = { fg = M.colors.blue },
	NeogitGraphPurple = { fg = M.colors.magenta },
	NeogitGraphCyan = { fg = M.colors.cyan },
	NeogitGraphBold = { bold = true },
}

M.export_kitty_theme = function()
	local c = M.colors
	local file = os.getenv("HOME") .. "/.config/kitty/" .. M.colorscheme_name .. ".conf"
	local contents = [[
	# FG / BG
	foreground %s
	background %s

	# Black
	color0 %s
	color8 %s

	# Red
	color1 %s
	color9 %s

	# Green
	color2  %s
	color10 %s

	# Yellow
	color3  %s
	color11 %s

	# Blue
	color4  %s
	color12 %s

	# Magenta
	color5  %s
	color13 %s

	# Cyan
	color6  %s
	color14 %s

	# White
	color7  %s
	color15 %s

	active_tab_foreground %s
	active_tab_background %s
	active_tab_font_style bold-italic
	inactive_tab_foreground %s
	inactive_tab_background %s
	inactive_tab_font_style normal

	cursor %s

	active_border_color %s
	inactive_border_color %s
	]]

	contents = string.format(contents, c.fg, c.bg, c.black, c.black_bright, c.red, c.red_bright, c.green, c.green_bright, c.yellow, c.yellow_bright, c.blue, c.blue_bright, c.magenta, c.magenta_bright, c.cyan, c.cyan_bright, c.white, c.white_bright, c.bg, c.green, c.bg_brighter, c.blue_mid_grey, c.green_greyish, c.green, c.grey_charcoal)

	vim.fn.mkdir(vim.fn.fnamemodify(file, ":h"), "p")
	local fd = assert(io.open(file, "w+"))
	fd:write(contents)
	fd:close()
end

M.setup = function()
	if vim.g.colors_name then
		vim.cmd("hi clear")
	end

	vim.o.termguicolors = true
	vim.g.colors_name = M.colorscheme_name

	for group, colors in pairs(M.highlights) do
		vim.api.nvim_set_hl(0, group, colors)
	end
end

M.setup()
