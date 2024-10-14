return {
	lsp_servers = {
		"lua_ls",
		"clangd",
		"csharp_ls",
		"bashls",
		"ts_ls",
		"eslint",
		"denols",
		-- TODO: fix
		-- "html",
		"cssls",
		-- TODO: fix
		-- "tailwindcss",
		"spectral",
		"marksman",
		"pylyzer",
		"rust_analyzer",
		"solidity_ls",
		"dockerls",
	},
	treesitter_langs = {
		"c",
		"cpp",
		"lua",
		"luadoc",
		"query",
		"html",
		"css",
		"tsx",
		"typescript",
		"javascript",
		"python",
		"bash",
		"diff",
		"json",
		"markdown",
		"yaml",
		"c_sharp",
		"cuda",
		"norg",
		"rust",
		"scss",
		"solidity",
		"dockerfile",
	},
	get_deno_or_prettier = function(bufnr)
		local clients = vim.lsp.get_clients({ bufnr = bufnr })
		for _, client in ipairs(clients) do
			if client.name == "denols" then
				vim.notify("deno")
				return { "deno_fmt" }
			end
		end
		vim.notify("prettier")
		return { "prettierd", "prettier", stop_after_first = true }
	end,
}
