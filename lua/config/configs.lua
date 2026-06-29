return {
	lsp_servers = {
		"lua_ls",
		"clangd",
		"bashls",
		"ts_ls",
		"eslint",
		"denols",
		"glsl_analyzer",
		"pyright",
		-- TODO: fix
		"html",
		"cssls",
		-- TODO: fix
		-- "tailwindcss",
		-- spectral-language-server was removed from npm (2026), use spectral CLI instead
		-- "spectral",
		"marksman",
		"rust_analyzer",
		"dockerls",
	},
	treesitter_langs = {
		"c",
		"cpp",
		"lua",
		"hlsl",
		"glsl",
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
		"markdown_inline",
		"yaml",
		"cuda",
		"rust",
		"solidity",
		"dockerfile",
	},
	get_deno_or_prettier = function(bufnr)
		local clients = vim.lsp.get_clients({ bufnr = bufnr })
		for _, client in ipairs(clients) do
			if client.name == "denols" then
				return { "deno_fmt" }
			end
		end
		return { "prettierd", "prettier", stop_after_first = true }
	end,
}
