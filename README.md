# NRunner

Simple and lightweight code runner for Neovim.
## What Can NRunner Do?
- Execute terminal commands that are mapped in a nrun.json or nrun.lua file in the projects root directory to run or build projects at the press of a button.
- Detects if a vscode launch.json file is present and executes the command in the 'program' field.
- Automatically maps a simple default run command to the current filetype if an NRunner file isn't found in the project root.

## Getting Started
NRunner should work with most versions of Neovim.
### Installation
Using [packer.nvim](https://github.com/wbthomason/packer.nvim)
```lua
use 'OrigamiDev-Pete/nrunner.nvim'
```
### Setup
Call the setup function in your init file
```lua
-- Empty setup uses defaults
require'nrunner'.setup()

-- Example defualt setup
require'nrunner'.setup {
    -- File names that Nrunner will check for.
	default_runner_files = { 'nrun.json', 'nrun.lua', 'nrunner.json', 'nrunner.lua' },
    -- Set path to the Nrunner file. If nil, will probe for a suitable file.
	runner_path = nil,
    -- Try to find a launch.json file if no Nrunner files are found and runner_path is nil.
	use_vscode_files = true,
    -- Use default keymaps.
	use_keymaps = true,
    -- Set project root_dir.
	root_dir = vim.fn.getcwd(),
    -- Use generated run commands if a Nrunner file is not found.
	generate_default_run_command = true,
}
```
## Commands
`:NRun` Run the project with the set run command. Takes an optional argument to pass to the run command.

`:NBuild` Build the project with the set build command. Takes an optional argument to pass to the  buidl command.

`:NRunSetRunner` Set the NRunner file. Expects a valid file path.

## Mappings
Default keymaps. These can be disabled by change the `use_keymaps` field to false in `Setup()`
```lua
vim.keymap.set('n', '<F5>', api.run, {remap = true})
vim.keymap.set('n', '<F6>', api.build, {remap = true})
```

## Using NRunner
- Create a file named 'nrun.json' to the project root. (Alternative NRunner file names can be found in the `default_runner_files` field)
- Setup the NRunner file with your desired commands, e.g.
```json
{
    "run": "dotnet run",
    "build": "dotnet build"
}
```
- If you've just set up the NRunner file you may need to call `:NRunSetRunner <path_to_run_file>` or reopen Neovim.
- Press F5 or call `:NRun` to run the file / Press F6 or call `:NBuild` to run the file.