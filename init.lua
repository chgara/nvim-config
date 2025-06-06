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
themes.set_theme("catppuccin-mocha")

-- Add keybinding to cycle themes
vim.keymap.set("n", "<leader>tt", function()
	require("config.themes").cycle_theme()
end, { desc = "Cycle colorscheme" })

-- Add keybinding to toggle transparency (works with pywal)
vim.keymap.set("n", "<leader>tb", function()
	require("config.themes").toggle_transparency()
end, { desc = "Toggle background transparency" })
