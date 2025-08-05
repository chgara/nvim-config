return {
	{
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				-- python = { "isort", "pyink" },
				json = { "prettierd", "prettier", stop_after_first = true },
				html = require("config.configs").get_deno_or_prettier,
				javascript = require("config.configs").get_deno_or_prettier,
				typescript = require("config.configs").get_deno_or_prettier,
				javascriptreact = require("config.configs").get_deno_or_prettier,
				typescriptreact = require("config.configs").get_deno_or_prettier,
				c = { "clang-format", lsp_format = "fallback", stop_after_first = true },
				cpp = { "clang-format", lsp_format = "fallback", stop_after_first = true },
				glsl = { "clang-format", lsp_format = "fallback", stop_after_first = true },
				vert = { "clang-format", lsp_format = "fallback", stop_after_first = true },
				frag = { "clang-format", lsp_format = "fallback", stop_after_first = true },
			},
			formatters = {
				clang_format = { prepend_args = { "-style=webkit" } },
			},
			format_on_save = false,
			format_after_save = function(bufnr)
				if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
					return
				end
				return { lsp_format = "fallback" }
			end,
		},
		init = function()
			vim.api.nvim_create_user_command("FormatDisable", function(args)
				if args.bang then
					-- FormatDisable! will disable formatting just for this buffer
					vim.b.disable_autoformat = true
				else
					vim.g.disable_autoformat = true
				end
			end, {
				desc = "Disable autoformat-on-save",
				bang = true,
			})
			vim.api.nvim_create_user_command("FormatEnable", function()
				vim.b.disable_autoformat = false
				vim.g.disable_autoformat = false
			end, {
				desc = "Re-enable autoformat-on-save",
			})
		end,
	},
	{
		"mason-org/mason.nvim",
		version = "^1.0.0",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"neovim/nvim-lspconfig",
			{ "mason-org/mason-lspconfig.nvim", version = "^1.0.0" },
		},
		config = function()
			require("mason").setup()

			-- Configure diagnostic display
			vim.diagnostic.config({
				virtual_text = true, -- Show diagnostic messages as virtual text
				signs = true, -- Show signs in the sign column
				underline = true, -- Underline diagnostics
				update_in_insert = true, -- Update diagnostics in insert mode
				severity_sort = true, -- Sort diagnostics by severity
			})

			require("mason-lspconfig").setup({
				automatic_installation = false,
				ensure_installed = require("config.configs").lsp_servers,
			})

			local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- stylua: ignore start
            local on_attach = function(client, bufnr)
                local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
                buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', { noremap=true, silent=true })
                buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', { noremap=true, silent=true })
                buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', { noremap=true, silent=true })
            end
			-- stylua: ignore end

			require("mason-lspconfig").setup_handlers({
				function(server_name) -- default handler (optional)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
						on_attach = on_attach,
					})
				end,
				["clangd"] = function()
					require("lspconfig").clangd.setup({
						on_attach = on_attach,
						capabilities = capabilities,
						-- compile commands can be under the build directory
						root_dir = require("lspconfig").util.root_pattern(
							"compile_commands.json",
							"compile_commands.jsonc",
							"build/compile_commands.json",
							"build/compile_commands.jsonc"
						),
					})
				end,
				["denols"] = function()
					require("lspconfig").denols.setup({
						on_attach = on_attach,
						capabilities = capabilities,
						root_dir = require("lspconfig").util.root_pattern("deno.json", "deno.jsonc"),
					})
				end,
				["ts_ls"] = function()
					require("lspconfig").ts_ls.setup({
						on_attach = on_attach,
						capabilities = capabilities,
						single_file_support = false,
						root_dir = require("lspconfig").util.root_pattern("package.json"),
					})
				end,
			})
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"onsails/lspkind-nvim",
			{
				"dcampos/cmp-emmet-vim",
				dependencies = { "mattn/emmet-vim" },
			},
			{
				"garymjr/nvim-snippets",
				dependencies = { "rafamadriz/friendly-snippets" },
				keys = require("config.keymaps").snippets,
				opts = {
					friendly_snippets = true,
				},
			},
			{
				"zbirenbaum/copilot-cmp",
				config = function()
					require("copilot_cmp").setup()
				end,
				dependencies = { "zbirenbaum/copilot.lua" },
			},
		},
		config = function()
			local cmp = require("cmp")
			local lspkind = require("lspkind")

			local has_words_before = function()
				if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
					return false
				end
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0
					and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
			end

			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

			require("cmp").setup({

				snippet = {
					expand = function(args)
						vim.snippet.expand(args.body)
					end,
				},

				sources = cmp.config.sources({
					{ name = "copilot" },
					{ name = "nvim_lsp" },
					{ name = "emmet_vim" },
					{ name = "snippets" },
				}, {
					{ name = "buffer" },
					{ name = "path" },
					{
						name = "lazydev",
						group_index = 0,
					},
				}),

				sorting = {
					priority_weight = 2,
					comparators = {
						require("copilot_cmp.comparators").prioritize,
						cmp.config.compare.offset,
						cmp.config.compare.exact,
						cmp.config.compare.score,
						cmp.config.compare.recently_used,
						cmp.config.compare.locality,
						cmp.config.compare.kind,
						cmp.config.compare.sort_text,
						cmp.config.compare.length,
						cmp.config.compare.order,
					},
				},

				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = false }),
					["<Tab>"] = vim.schedule_wrap(function(fallback)
						if cmp.visible() and has_words_before() then
							cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
						else
							fallback()
						end
					end),
				}),

				-- TODO: check this
				formatting = {
					format = lspkind.cmp_format({
						mode = "symbol_text",
						ellipsis_char = "󰘦",
						show_labelDetails = true,
						symbol_map = { Copilot = "" },
						maxwidth = function()
							return math.floor(0.45 * vim.o.columns)
						end,
						before = function(entry, vim_item)
							return vim_item
						end,
					}),
				},

				enabled = function()
					local disabled = { IncRename = true }
					local cmd = vim.fn.getcmdline():match("%S+")
					return not disabled[cmd] or cmp.close()
				end,
			})
		end,
	},
	{
		"smjonas/inc-rename.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("inc_rename").setup({})
			vim.keymap.set("n", "rn", function()
				return ":IncRename " .. vim.fn.expand("<cword>")
			end, { expr = true })
		end,
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup({
				check_ts = true,
				ts_config = {},
			})
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		event = "InsertEnter",
		config = function()
			require("nvim-ts-autotag").setup()
			vim.lsp.handlers["textDocument/publishDiagnostics"] =
				vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
					update_in_insert = true,
				})
		end,
	},
	{
		"zbirenbaum/copilot.lua",
		-- enabled = false,
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("copilot").setup({
				filetypes = {
					help = true,
					markdown = true,
				},
				panel = { enabled = false },
				copilot_model = "gpt-4o-copilot",
				suggestion = { enabled = false },
			})
		end,
	},
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		build = "make",
		version = false, -- Never set this value to "*"! Never!
		opts = {
			-- provider = "claude",
			provider = "copilot",
			providers = {
				copilot = {
					-- model = "claude-3.5-sonnet",
					-- model = "claude-3.7-sonnet",
					-- model = "claude-3.7-sonnet-thought",
					-- model = "gemini-2.5-pro",
					-- model = "o4-mini",
					-- model = "o3-mini",
					-- model = "claude-sonnet-4-thought",
					model = "claude-sonnet-4",
				},
			},
			hints = { enabled = true },
			web_search_engine = {
				provider = "tavily",
			},

			behaviour = {
				auto_suggestions = false,
			},

			windows = {
				width = 25,
				wrap = true,
				sidebar_header = {
					align = "left",
					rounded = false,
				},
			},
		},
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
			"zbirenbaum/copilot.lua",
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			{
				-- support for image pasting
				"HakonHarnes/img-clip.nvim",
				event = "VeryLazy",
				opts = {
					-- recommended settings
					default = {
						embed_image_as_base64 = false,
						prompt_for_file_name = false,
						drag_and_drop = {
							insert_mode = true,
						},
						-- required for Windows users
						use_absolute_path = true,
					},
				},
			},
			{
				"MeanderingProgrammer/render-markdown.nvim",
				opts = {
					enabled = true,
					file_types = { "markdown", "Avante" },
				},
				ft = { "markdown", "Avante" },
				dependencies = {
					{
						"3rd/image.nvim",
						build = false,
						opts = {
							backend = "ueberzug",
							integrations = {
								markdown = {
									filetypes = { "markdown", "vimwiki", "Avante" },
								},
							},
						},
						dependencies = { "luarocks.nvim" },
					},
				},
			},
		},
	},
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
		dependencies = {
			{ "Bilal2453/luvit-meta", lazy = true },
		},
	},
}
