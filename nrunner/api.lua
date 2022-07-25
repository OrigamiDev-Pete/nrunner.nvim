local config = require'nrunner.config'
local util = require'nrunner.util'

local M = {}

M.setup = function () 
	C = vim.api.nvim_create_user_command
	C('NRun', M.run, {nargs='?'})
	C('NRunBuild', M.build, {nargs='?'})
	C('NRunSetRunner', M.set_runner, {nargs=1, complete='file'})

	if config.options.use_keymaps then
		K = vim.keymap.set
		K('n', '<F5>', M.run, {remap = true})
		K('n', '<F6>', M.build, {remap = true})
	end
end

M.run = function (args)
	if config.run_options.run == nil then
		print('No run command found.\nCreate an Nrunner file with a "run" field.')
		return
	end

	local run_command = config.run_options.run
	if args then
		if args.args then
			run_command = run_command..' '..args.args
		end
	end

	if config.run_options.terminal == nil then
		vim.api.nvim_command('!'..run_command)
	-- elseif config.run_options.terminal == 'float' then
	-- 	run_command = util.expand(run_command)
	-- 	local buf = vim.api.nvim_create_buf(false, true)
	-- 	local window = vim.api.nvim_open_win(buf, true, { style = 'minimal', relative='win', border='double', width = 100, height = 10, row=0, col=0, anchor='NE'  })
	-- 	vim.fn.termopen(run_command)
	-- elseif config.run_options.terminal == 'terminal' then
	-- 	vim.cmd('vsplit | wincmd l')
	-- 	local buf = vim.api.nvim_create_buf(false, false)
	-- 	vim.api.nvim_set_current_buf(buf)
	-- 	vim.cmd('vertical resize 80')
	-- 	run_command = util.expand(run_command)
	-- 	vim.fn.termopen(run_command)
	end
end

M.build = function (args)
	if config.run_options.build == nil then
		print('No build command found.\nCreate an Nrunner file with a "build" field.')
		return
	end

	local build_command = config.run_options.build
	if args then
		if args.args then
			build_command = build_command..' '..args.args
		end
	end

	if config.run_options.terminal == nil then
		vim.api.nvim_command('!'..build_command)
	end
end

M.set_runner = function (args)
	config.nrunner_file = args.args
	util.get_run_options(args.args)
end

return M
