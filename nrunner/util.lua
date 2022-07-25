local config = require'nrunner.config'

local M = {}

M.locate_runner = function ()
	local root_dir = config.options.root_dir
	for _, v in ipairs(config.options.default_runner_files) do
		if vim.fn.filereadable(root_dir..'\\'..v) ~= 0 then
			return root_dir..'\\'..v
		end
	end
	if config.options.use_vscode_files then
		if vim.fn.filereadable(root_dir..'\\.vscode\\launch.json') ~= 0 then
			return root_dir..'\\.vscode\\launch.json'
		end
	end
	return nil
end

M.get_run_options = function (path)
	-- Handle vscode launch files
	if vim.fn.match(path, 'vscode') ~= -1 then
		return M.get_run_options_vs(path)
	end

	if vim.endswith(path, '.lua') then
		local f = loadfile(path)
		if f then
			config.run_options = vim.tbl_deep_extend("force", {}, config.run_options, f())
		end
	else
		local file = vim.fn.readfile(path)
		config.run_options = vim.fn.json_decode(file)
	end
end

M.get_run_options_vs = function (path)
	local file = vim.fn.readfile(path)
	local uncommented_file = {} -- remove // comments from json
	for _, value in ipairs(file) do
		if vim.fn.match(value, '//') == -1 then
			table.insert(uncommented_file, value)
		end
	end
	local vs_data = vim.fn.json_decode(uncommented_file)
	local vs_command = vs_data.configurations[1].program
	config.run_options.command = vim.fn.substitute(vs_command, [[${workspaceRoot}]], vim.fn.escape(config.options.root_dir, '\\'), 'g')
end

M.generate_runner = function ()

end

M.expand = function (string)
	if vim.fn.match(string, '%') ~= -1 then
		local current_file = vim.fn.expand('%:p')
		print(current_file)
		return vim.fn.substitute(string, '%', vim.fn.escape(current_file, '\\'), 'g')
	end

	return string
end

return M
