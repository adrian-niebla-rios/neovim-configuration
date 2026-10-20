return function()
	local bufferline = require("bufferline")

	-- Current tab: blue background (kanagawa's selection color) on every part
	-- of the tab, with bright, bold, non-italic text
	local palette = require("kanagawa.colors").setup().palette
	local selected_bg = palette.waveBlue2
	local selected = {}
	for _, part in ipairs({
		"numbers", "close_button", "modified", "duplicate", "separator", "indicator", "pick",
		"diagnostic", "hint", "hint_diagnostic", "info", "info_diagnostic",
		"warning", "warning_diagnostic", "error", "error_diagnostic",
	}) do
		selected[part .. "_selected"] = { bg = selected_bg }
	end
	selected.buffer_selected = { bg = selected_bg, fg = palette.fujiWhite, bold = true, italic = false }
	selected.numbers_selected = { bg = selected_bg, fg = palette.fujiWhite, bold = true, italic = false }
	selected.indicator_selected = { bg = selected_bg, fg = palette.crystalBlue }

	bufferline.setup({
		highlights = selected,
		options = {
			mode = "buffers", -- set to "tabs" to only show tabpages instead
			style_preset = bufferline.style_preset.default, -- or bufferline.style_preset.minimal,
			themable = true, -- allows highlight groups to be overriden i.e. sets highlights as default
			-- Show each tab's position (1, 2, 3, ...), as used by <leader>t1 .. <leader>t9
			numbers = "ordinal",
			--numbers = function(opts)
			--	return string.format("%s·%s", opts.raise(opts.id), opts.lower(opts.ordinal))
			--end,
			indicator = {
				icon = "▎", -- this should be omitted if indicator style is not 'icon'
				style = "icon",
			},
			diagnostics = "nvim_lsp",
			diagnostics_update_in_insert = false,
			offsets = {
				{
					filetype = "neo-tree",
					text = require("custom_opts").file_explorer_title,
					text_align = "left",
					separator = true,
				},
			},
			color_icons = true, -- whether or not to add the filetype icon highlights
			separator_style = require("custom_opts").tab_style,
			hover = {
				enabled = true,
				delay = 200,
				reveal = { "close" },
			},
		},
	})
end
