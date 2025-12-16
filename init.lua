vim.cmd([[set tabstop=4]])
vim.cmd([[set expandtab]])
vim.cmd([[set smartindent]])
vim.cmd([[set shiftwidth=4]])
vim.cmd([[set softtabstop=4]])
vim.cmd([[set number relativenumber]])
vim.cmd([[set wrap!]])
vim.opt.laststatus = 3
vim.opt.background = "dark"

vim.api.nvim_set_keymap("n", "<C-c>", '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<C-c>", '"+y', { noremap = true, silent = true })

vim.keymap.set("v", "<C-v>", "i<C-r><C-o>+<ESC>l=`[`]$", { desc = "Paste block and indent" })
vim.keymap.set("n", "<C-v>", "i<C-r><C-o>+<ESC>l=`[`]$", { desc = "Paste block and indent" })

local augroup = vim.api.nvim_create_augroup("numbertoggle", {})

vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "CmdlineLeave", "WinEnter" }, {
	pattern = "*",
	group = augroup,
	callback = function()
		if vim.o.nu and vim.api.nvim_get_mode().mode ~= "i" then
			vim.opt.relativenumber = true
		end
	end,
})

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "CmdlineEnter", "WinLeave" }, {
	pattern = "*",
	group = augroup,
	callback = function()
		if vim.o.nu then
			vim.opt.relativenumber = false
		end
	end,
})

require("config.lazy")

-- vim.api.nvim_set_hl(0, 'LineNrAbove', { fg='#51B3EC', bold=true })
-- vim.api.nvim_set_hl(0, 'LineNr', { fg='#fffb7b', bold=true })
-- vim.api.nvim_set_hl(0, 'LineNrBelow', { fg='#FB508F', bold=true })

-- vim.cmd [[
--   highlight Normal guibg=none
--   highlight NonText guibg=none
--   highlight Normal ctermbg=none
--   highlight NonText ctermbg=none
-- ]]

-- Initialize theme system
local themes = require("config.themes")
themes.set_theme("rose-pine")

-- Add keybinding to cycle themes
vim.keymap.set("n", "<leader>tt", function()
	require("config.themes").cycle_theme()
end, { desc = "Cycle colorscheme" })

-- Add keybinding to toggle transparency (works with pywal)
--
local isTransparencyEnabled = true
if isTransparencyEnabled then
	require("config.themes").toggle_transparency()
end

vim.keymap.set("n", "<leader>tb", function()
	require("config.themes").toggle_transparency()
end, { desc = "Toggle background transparency" })

--
-- TERMINAL STUFF
--
--
vim.keymap.set("t", "<esc>t", "<c-\\><c-n>")

local state = {
	floating = {
		buf = -1,
		win = -1,
	},
}

local function create_floating_window(opts)
	opts = opts or {}
	local width = opts.width or math.floor(vim.o.columns * 0.6)
	local height = opts.height or math.floor(vim.o.lines * 0.5)

	-- Calculate the position to center the window
	local col = math.floor((vim.o.columns - width) / 2)
	local row = math.floor((vim.o.lines - height) / 2)

	-- Create a buffer
	local buf = nil
	if vim.api.nvim_buf_is_valid(opts.buf) then
		buf = opts.buf
	else
		buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer
	end

	-- Define window configuration
	local win_config = {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
		style = "minimal", -- No borders or extra UI elements
		border = "rounded",
	}

	-- Create the floating window
	local win = vim.api.nvim_open_win(buf, true, win_config)

	return { buf = buf, win = win }
end

local toggle_terminal = function()
	if not vim.api.nvim_win_is_valid(state.floating.win) then
		state.floating = create_floating_window({ buf = state.floating.buf })
		if vim.bo[state.floating.buf].buftype ~= "terminal" then
			vim.cmd.terminal()
		end
		vim.cmd.startinsert()
	else
		vim.api.nvim_win_hide(state.floating.win)
	end
end

-- Example usage:
-- Create a floating window with default dimensions
vim.api.nvim_create_user_command("Floatterminal", toggle_terminal, {})
vim.keymap.set({ "n", "t" }, "tt", toggle_terminal)
