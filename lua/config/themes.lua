local M = {}

M.themes = {
	"cyberdream",
	"synthwave84",
	"github_dark_default",
	"rose-pine",
	"fluoromachine",
}

-- Track transparency state
M.transparent = false

function M.set_theme(theme_name)
	local success, _ = pcall(vim.cmd.colorscheme, theme_name)
	if success then
		vim.g.current_theme = theme_name
		-- Apply transparency if enabled
		if M.transparent then
			M.enable_transparency()
		end
	else
		vim.notify("Theme " .. theme_name .. " not found!", vim.log.levels.ERROR)
	end
end

-- Function to enable transparency
function M.enable_transparency()
	vim.api.nvim_command("highlight Normal guibg=NONE ctermbg=NONE")
	vim.api.nvim_command("highlight NormalFloat guibg=NONE ctermbg=NONE")
	vim.api.nvim_command("highlight NonText guibg=NONE ctermbg=NONE")
	vim.api.nvim_command("highlight SignColumn guibg=NONE ctermbg=NONE")
	vim.api.nvim_command("highlight NormalNC guibg=NONE ctermbg=NONE")
	vim.api.nvim_command("highlight MsgArea guibg=NONE ctermbg=NONE")
	vim.api.nvim_command("highlight TelescopeBorder guibg=NONE ctermbg=NONE")
	vim.api.nvim_command("highlight TelescopeNormal guibg=NONE ctermbg=NONE")
	M.transparent = true
end

-- Function to disable transparency
function M.disable_transparency()
	-- Reset to current colorscheme defaults
	local current_theme = vim.g.current_theme or M.themes[1]
	pcall(vim.cmd.colorscheme, current_theme)
	M.transparent = false
end

-- Toggle transparency
function M.toggle_transparency()
	if M.transparent then
		M.disable_transparency()
		vim.notify("Transparency disabled", vim.log.levels.INFO)
	else
		M.enable_transparency()
		vim.notify("Transparency enabled", vim.log.levels.INFO)
	end
end

function M.cycle_theme()
	local current_theme = vim.g.current_theme or M.themes[1]
	local current_index = 1

	for i, theme in ipairs(M.themes) do
		if theme == current_theme then
			current_index = i
			break
		end
	end

	local next_index = current_index % #M.themes + 1
	M.set_theme(M.themes[next_index])
end

return M
