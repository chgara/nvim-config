return {
    bufferline = {
        { "<A-Tab>", "<cmd>:bnext<cr>", desc = "Navigate to next buffer" },
    },
    nvim_tree = {
        { "<c-b>", "<cmd>NvimTreeFindFileToggle<cr>", desc = "Toggle Nvim Tree" },
    },
    telescope = {
        { "ff", "<cmd>Telescope find_files<cr>", desc = "Find files name" },
        { "fg", "<cmd>Telescope live_grep<cr>", desc = "Find content" },
        { "fb", "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
        { "fh", "<cmd>Telescope help_tags<cr>", desc = "Find help" },
    },
    snippets = {
        {
            "<Tab>",
            function()
                if vim.snippet.active({ direction = 1 }) then
                    vim.schedule(function()
                        vim.snippet.jump(1)
                    end)
                    return
                end
                return "<Tab>"
            end,
            mode = "i",
            expr = true,
            silent = true,
        },
        {
            "<Tab>",
            function()
                vim.schedule(function()
                    vim.snippet.jump(1)
                end)
            end,
            mode = "s",
            expr = true,
            silent = true,
        },
        {
            "<S-Tab>",
            function()
                if vim.snippet.active({ direction = -1 }) then
                    vim.schedule(function()
                        vim.snippet.jump(-1)
                    end)
                    return
                end
                return "<S-Tab>"
            end,
            expr = true,
            silent = true,
            mode = { "i", "s" },
        }
    }
}
