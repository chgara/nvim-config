return {
	{
		"scottmckendry/cyberdream.nvim",
		lazy = false,
		opts = {
			transparent = true,
		},
		priority = 1000,
	},
	{
		"rose-pine/neovim",
		name = "rose-pine",
		lazy = false,
		priority = 1000,
		opts = {
			variant = "moon",
		},
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
		"projekt0n/github-nvim-theme",
		name = "github-theme",
		lazy = false,
		priority = 1000,
		config = function()
			require("github-theme").setup({})
		end,
	},
}
