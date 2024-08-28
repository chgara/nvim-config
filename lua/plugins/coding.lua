
return {
    {
        "williamboman/mason.nvim",
        event = {"BufReadPre", "BufNewFile"},
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "neovim/nvim-lspconfig",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function ()
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = require("config.configs").lsp_servers
            })

            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            require("mason-lspconfig").setup_handlers {
                function (server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities,
                        on_attach = function(client, bufnr)
                            local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
                            buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', { noremap=true, silent=true })
                            buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', { noremap=true, silent=true })
                            buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', { noremap=true, silent=true })
                        end
                    }
                end,
                ["csharp_ls"] = function ()
                    require("lspconfig").tsserver.setup {
                        capabilities = capabilities,
                        on_attach = function(client, bufnr)
                            local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
                            buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', { noremap=true, silent=true })
                            buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', { noremap=true, silent=true })
                            buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', { noremap=true, silent=true })
                        end,
                        settings = { rootMarkers = { "global.json", "Directory.Build.props", "*.sln", "*.csproj" } }
                    }
                end
            }
        end
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
                "garymjr/nvim-snippets",
                dependencies = { "rafamadriz/friendly-snippets" },
                keys = require("config.keymaps").snippets,
                opts = {
                    friendly_snippets = true,
                }
            },
            {
                "zbirenbaum/copilot-cmp",
                config = function()
                    require("copilot_cmp").setup()
                end,
                dependencies = { 'zbirenbaum/copilot.lua' },
            },
        },
        config = function()
            local cmp = require('cmp')
            local lspkind = require('lspkind')

            local has_words_before = function()
                if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
            end

            require("cmp").setup({

                snippet = {
                    expand = function(args) vim.snippet.expand(args.body) end,
                },

                sources = cmp.config.sources({
                    { name = "copilot" },
                    { name = "nvim_lsp" },
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
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm({ select = false }),
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
                        mode = 'symbol_text',
                        ellipsis_char = '󰘦',
                        show_labelDetails = true,
                        symbol_map = { Copilot = "" },
                        maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
                        before = function (entry, vim_item)
                            return vim_item
                        end
                    })
                },

                enabled = function()
                    local disabled = { IncRename = true }
                    local cmd = vim.fn.getcmdline():match("%S+")
                    return not disabled[cmd] or cmp.close()
                end,
            })

            local cmp_autopairs = require('nvim-autopairs.completion.cmp')
            cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
        end,
    },
    {
        "smjonas/inc-rename.nvim",
        event = {"BufReadPre", "BufNewFile"},
        config = function()
            require("inc_rename").setup({})
            vim.keymap.set("n", "rn", function()
                return ":IncRename " .. vim.fn.expand("<cword>")
            end, { expr = true })
        end,
    },
    -- {
    --     -- TODO: Check
    --     'windwp/nvim-ts-autotag',
    --     event = "InsertEnter",
    --     opts = {}
    -- },
    {
        'zbirenbaum/copilot.lua',
        event = {"BufReadPre", "BufNewFile"},
        config = function ()
            require("copilot").setup({
                filetypes = {
                    help = true,
                    markdown = true,
                },
                panel = { enabled = false },
                suggestion = { enabled = false },
            })
        end,
    },
    {
        "yetone/avante.nvim",
        event = {"BufReadPre", "BufNewFile"},
        build = "make",
        opts = {
            provider = "copilot",
            hints = { enabled = true },
            windows = {
                width = 25,
                wrap = true,
                sidebar_header = {
                    align = "center",
                    rounded = false,
                },
            }
        },
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            'zbirenbaum/copilot.lua',
            "stevearc/dressing.nvim",
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            {
                'MeanderingProgrammer/render-markdown.nvim',
                opts = {
                    enabled = true,
                    file_types = { "markdown", "Avante" },
                },
                ft = { "markdown", "Avante" },
            },
        },
    },
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true,
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
        }
    },
}
