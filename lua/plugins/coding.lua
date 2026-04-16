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
            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(args)
                    local bufnr = args.buf
                    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
                    buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', { noremap=true, silent=true })
                    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', { noremap=true, silent=true })
                    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', { noremap=true, silent=true })
                end,
            })
			-- stylua: ignore end

			vim.lsp.config("*", {
				capabilities = capabilities,
			})

			-- clangd: also look for compile_commands.json under build/
			vim.lsp.config("clangd", {
				root_dir = function(bufnr, on_dir)
					local fname = vim.api.nvim_buf_get_name(bufnr)
					on_dir(
						require("lspconfig.util").root_pattern(
							"compile_commands.json",
							"compile_commands.jsonc",
							"build/compile_commands.json",
							"build/compile_commands.jsonc"
						)(fname)
					)
				end,
			})

			vim.lsp.enable(require("config.configs").lsp_servers)
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
		dependencies = { "copilotlsp-nvim/copilot-lsp" },
		config = function()
			require("copilot").setup({
				filetypes = {
					help = true,
					markdown = true,
				},
				panel = { enabled = false },
				copilot_model = "gpt-41-copilot",
				suggestion = { enabled = false },
			})
		end,
	},
	{
		"nickjvandyke/opencode.nvim",
		version = "*", -- Latest stable release
		keys = require("config.keymaps").opencode,
		dependencies = {
			{
				-- `snacks.nvim` integration is recommended, but optional
				---@module "snacks" <- Loads `snacks.nvim` types for configuration intellisense
				"folke/snacks.nvim",
				optional = false,
				opts = {
					input = {}, -- Enhances `ask()`
					picker = { -- Enhances `select()`
						actions = {
							opencode_send = function(...)
								return require("opencode").snacks_picker_send(...)
							end,
						},
						win = {
							input = {
								keys = {
									["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
								},
							},
						},
					},
				},
			},
		},
		config = function()
			local function get_opencode_theme()
				return vim.o.background == "light" and "gruvbox" or "tokyonight"
			end

			local opencode = require("opencode")
			local original_toggle = opencode.toggle
			opencode.toggle = function(...)
				local provider = require("opencode.config").provider
				if provider and provider.opts then
					provider.opts.env = provider.opts.env or {}
					provider.opts.env.OPENCODE_CONFIG_CONTENT = vim.json.encode({
						theme = get_opencode_theme(),
					})
				end
				return original_toggle(...)
			end

			---@type opencode.Opts
			vim.g.opencode_opts = {
				-- Your configuration, if any; goto definition on the type or field for details
			}

			vim.o.autoread = true -- Required for `opts.events.reload`
		end,
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
