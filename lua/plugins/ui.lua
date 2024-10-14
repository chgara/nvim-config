return {
	{
		"nvim-lualine/lualine.nvim",
		lazy = false,
		priority = 900,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"AndreM222/copilot-lualine",
			"arkav/lualine-lsp-progress",
		},
		opts = {
			options = {
				theme = "horizon",
				disabled_filetypes = {
					statusline = { "Avante" },
					winbar = { "Avante" },
				},
			},
			sections = {
				lualine_c = { "filename", "lsp_progress" },
				lualine_x = { { "copilot", show_colors = true }, "encoding", "fileformat", "filetype" },
			},
		},
	},
	{
		"akinsho/toggleterm.nvim",
		event = "VeryLazy",
		version = "*",
		opts = {
			size = 15,
			open_mapping = [[<space>t]],
		},
	},
	{

		"akinsho/bufferline.nvim",
		lazy = false,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = require("config.keymaps").bufferline,
		opts = {
			options = {
				diagnostics = "nvim_lsp",
				always_show_bufferline = true,
				offsets = {
					{
						filetype = "NvimTree",
						text = "File Explorer",
						highlight = "Directory",
						separator = true,
					},
				},
			},
		},
	},
	{
		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("alpha").setup(require("alpha.themes.dashboard").config)
		end,
	},
	{
		"nvim-tree/nvim-tree.lua",
		lazy = true,
		init = function()
			vim.opt.termguicolors = true
		end,
		---@module "nvim-tree"
		opts = {
			view = { width = 40 },
			actions = {
				open_file = {
					window_picker = {
						enable = false,
					},
				},
			},
			diagnostics = {
				enable = true,
				icons = {
					hint = "",
					info = "",
					warning = "",
					error = "",
				},
			},
			renderer = {
				highlight_git = "icon",
				highlight_diagnostics = "icon",
				indent_markers = {
					enable = true,
				},
				icons = {
					git_placement = "before",
					diagnostics_placement = "right_align",
					show = {
						file = true,
						folder = true,
						folder_arrow = false,
						git = true,
					},
				},
			},
		},
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = require("config.keymaps").nvim_tree,
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			lsp = {
				override = {
					["cmp.entry.get_documentation"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				},
			},
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = true,
				inc_rename = true,
				lsp_doc_border = false,
			},
		},
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
	},
	{ "nvim-tree/nvim-web-devicons", lazy = true },
	{ "stevearc/dressing.nvim", event = "VeryLazy" },
}
