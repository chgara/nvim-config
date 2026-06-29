return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" }, -- if you use the mini.nvim suite
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },        -- if you use standalone mini plugins
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {},
	},
	{
		"sindrets/diffview.nvim",
		event = "VeryLazy",
		opts = {
			view = {
				merge_tool = {
					layout = "diff3_mixed",
					disable_diagnostics = true, -- Temporarily disable diagnostics for diff buffers while in the view.
					winbar_info = true,
				},
			},
		},
	},
	{
		"nvim-telescope/telescope.nvim",
		lazy = true,
		branch = "master",
		config = function()
			require("telescope").setup({
				extensions = {
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
				},
			})
			require("telescope").load_extension("fzf")
		end,
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				lazy = true,
				build = "make",
			},
		},
		keys = require("config.keymaps").telescope,
	},
	{
		"rmagatti/auto-session",
		lazy = false,
		init = function()
			vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
			vim.cmd([[command! Qa :qa]])
			vim.cmd([[command! Q :q]])
			vim.cmd([[command! S :SessionSave]])
			vim.cmd([[command! DS :SessionDelete]])
		end,
		opts = {
			session_lens = {
				load_on_setup = false,
			},
			auto_save_enabled = false,
			auto_restore_enabled = true,
			bypass_session_save_file_types = { "alpha", "dashboard" },
			auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		-- Upstream requirement: v1.0 main branch does not support lazy-loading.
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local langs = require("config.configs").treesitter_langs
			require("nvim-treesitter").install(langs)

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
				callback = function(ev)
					local ok = pcall(vim.treesitter.start, ev.buf)
					if ok then
						vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
				end,
			})
		end,
		dependencies = {
			{
				"lukas-reineke/indent-blankline.nvim",
				main = "ibl",
				opts = {},
			},
		},
	},
	{
		"folke/todo-comments.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},
	{ "folke/which-key.nvim", lazy = true },
	{ "lambdalisue/vim-suda", event = "VeryLazy" },
}
