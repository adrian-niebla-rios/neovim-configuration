return function()
	local cmp = require("cmp")
	local keys = require("custom_keys")

	-- Select another item `count` entries away if the menu is open,
	-- otherwise let the key do what it normally does in insert mode
	local function select_or_fallback(select, count)
		return function(fallback)
			if cmp.visible() then
				select({ count = count })
			else
				fallback()
			end
		end
	end
	local page_size = 5 -- items skipped by the page up/down keys

	cmp.setup({
		snippet = {
			-- Select the luasnip engine here. You can switch to another engine.
			expand = function(args)
				-- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
				require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
				-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
				-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
			end,
		},
		window = {
			completion = cmp.config.window.bordered({
				border = "rounded",
				winhighlight = "",
				minwidth = 60,
			}),
			documentation = cmp.config.window.bordered({
				border = "rounded",
				winhighlight = "",
			}),
		},
		formatting = {
			format = require("lspkind").cmp_format({
				mode = "symbol_text",
			}),
		},
		mapping = cmp.mapping.preset.insert({
			["<C-b>"] = cmp.mapping.scroll_docs(-4),
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			["<C-Space>"] = cmp.mapping.complete(),
			["<C-e>"] = cmp.mapping.abort(),
			["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
			["<Tab>"] = function(fallback)
				if cmp.visible() then
					cmp.select_next_item()
				else
					fallback()
				end
			end,
			[keys.cmp_next] = select_or_fallback(cmp.select_next_item, 1),
			[keys.cmp_prev] = select_or_fallback(cmp.select_prev_item, 1),
			[keys.cmp_page_down] = select_or_fallback(cmp.select_next_item, page_size),
			[keys.cmp_page_up] = select_or_fallback(cmp.select_prev_item, page_size),
		}),
		sources = cmp.config.sources({
			{ name = "nvim_lsp" },
		}, {
			{ name = "buffer" },
			{ name = "path" },
		}),
	})

	-- `/` cmdline setup.
	cmp.setup.cmdline("/", {
		mapping = cmp.mapping.preset.cmdline(),
		sources = {
			{ name = "buffer" },
		},
	})

	-- `:` cmdline setup.
	cmp.setup.cmdline(":", {
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({
			{ name = "path" },
		}, {
			{
				name = "cmdline",
				option = {
					ignore_cmds = { "Man", "!" },
				},
			},
		}),
	})

	-- If you want insert `(` after select function or method item
	local cmp_autopairs = require("nvim-autopairs.completion.cmp")
	cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end
