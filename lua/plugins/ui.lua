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
		keys = require("config.keymaps").toggleterm,
		opts = {
			size = 15,
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
		"sphamba/smear-cursor.nvim",
		event = "VeryLazy",
		priority = 5,
		opts = {},
	},
	{
		"rachartier/tiny-glimmer.nvim",
		event = "VeryLazy",
		enabled = false,
		priority = 10,
		opts = {
			enabled = true,

			overwrite = {
				auto_map = true,
				yank = {
					enabled = true,
					default_animation = "fade",
				},
				search = {
					enabled = true,
					default_animation = "pulse",
					next_mapping = "n",
					prev_mapping = "N",
				},
				paste = {
					enabled = true,
					default_animation = "reverse_fade",
					paste_mapping = "p",
					Paste_mapping = "P",
				},
				undo = {
					enabled = true,
					default_animation = {
						name = "fade",
						settings = {
							from_color = "DiffDelete",
							max_duration = 500,
							min_duration = 500,
						},
					},
					undo_mapping = "u",
				},
				redo = {
					enabled = false,

					default_animation = {
						name = "fade",

						settings = {
							from_color = "DiffAdd",

							max_duration = 500,
							min_duration = 500,
						},
					},

					redo_mapping = "<c-r>",
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
