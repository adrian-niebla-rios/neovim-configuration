-- Open a file "in place": after a picker (Telescope, Neo-tree) opens a file,
-- close the buffer it replaced, so the file takes over the current tab instead
-- of adding a new one. The replaced buffer is kept if it has unsaved changes,
-- is still shown in another window, or isn't a normal file buffer.
local M = {}

-- Remember which buffer every window shows before opening
function M.snapshot()
	local before = {}
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		before[win] = vim.api.nvim_win_get_buf(win)
	end
	return before
end

local function closable(buf)
	return vim.api.nvim_buf_is_valid(buf)
		and vim.bo[buf].buflisted
		and vim.bo[buf].buftype == ""
		and not vim.bo[buf].modified
		and #vim.fn.win_findbuf(buf) == 0
end

-- Close the buffers that were replaced in a window since `before`
function M.close_replaced(before)
	for win, old in pairs(before) do
		if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) ~= old and closable(old) then
			vim.api.nvim_buf_delete(old, {})
		end
	end
end

-- Run `open` (a function that opens a file) and close what it replaced
function M.run(open)
	local before = M.snapshot()
	open()
	M.close_replaced(before)
end

return M
