local util = require'nrunner.util'
local api = require'nrunner.api'

local M = {}

M.setup = function (opts)
	local config = require'nrunner.config'.setup(opts)
	if config.options.runner_path then
		if vim.fn.filereadable(vim.fn.expand(config.options.runner_path)) ~= 0 then
			util.get_run_options(config.options.runner_path)
		else
			print('Could not find '..config.options.runner_path)
		end
	else
		-- try locating nrunner file
		local nrunner_file = util.locate_runner()
		if nrunner_file then
			util.get_run_options(nrunner_file)
		end
	end

	api.setup()
end

M.setup()

return M
