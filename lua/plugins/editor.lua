return {
    {
        'nvim-telescope/telescope.nvim',
        lazy = true,
        tag = '0.1.8',
        config = function ()
            require('telescope').setup {
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
	                }
                }
            }
            require('telescope').load_extension 'fzf'
        end,
        dependencies = {
            'nvim-lua/plenary.nvim',
            {
	            'nvim-telescope/telescope-fzf-native.nvim',
    	        lazy = true,
                build = 'make'
            },
        },
        keys = require("config.keymaps").telescope,
    },
    {
        'rmagatti/auto-session',
        lazy = false,
        init = function()
            vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
            vim.cmd [[command! Qa :qa]]
            vim.cmd [[command! Q :q]]
            vim.cmd [[command! S :SessionSave]]
            vim.cmd [[command! DS :SessionDelete]]
        end,
        opts = {
            session_lens = {
                load_on_setup = false,
            },
            auto_save_enabled = false,
            auto_restore_enabled = true,
            bypass_session_save_file_types = { 'alpha', 'dashboard' },
            auto_session_suppress_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
        },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        event = {"VeryLazy", "BufReadPre", "BufNewFile"},
        build = function()
            require("nvim-treesitter.install").update({ with_sync = true })()
        end,
        config = function ()
            require("nvim-treesitter.configs").setup({
                sync_install = false,
                indent = { enable = true },
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                ensure_installed = require("config.configs").treesitter_langs
            })
        end,
        dependencies = {
            {
                "lukas-reineke/indent-blankline.nvim",
                main = "ibl",
                opts = {},
            },
        }
    },
    {
        "folke/todo-comments.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {}
    },
    { "folke/which-key.nvim", lazy = true },
    { "lambdalisue/vim-suda", event = "VeryLazy" },
}
