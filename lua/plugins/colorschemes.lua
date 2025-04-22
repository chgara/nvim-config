return {
	-- {
	-- 	"nyoom-engineering/oxocarbon.nvim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- },
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			-- transparent = true,
			-- styles = {
			--   sidebars = "transparent",
			--   floats = "transparent",
			-- },
		},
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		opts = {},
	},
	{
		"lunarvim/synthwave84.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
	},
	{
		"maxmx03/fluoromachine.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			local fm = require("fluoromachine")

			fm.setup({
				glow = true,
				theme = "retrowave",
				transparent = false,
			})
		end,
	},
	{
		"rafi/awesome-vim-colorschemes",
		lazy = false,
		priority = 1000,
		config = function() end,
		opts = {},
	},
}
