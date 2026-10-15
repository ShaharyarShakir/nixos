return {
	"CRAG666/code_runner.nvim",
	lazy = false,
	dependencies = {
		"akinsho/toggleterm.nvim",
	},
	config = function()
		require("code_runner").setup({
			mode = "toggleterm", -- <-- Use toggleterm to open terminals
			toggleterm = {
				direction = "float", -- use a floating terminal from toggleterm
				-- optional: override float_opts here if you want custom style
			},
			startinsert = true,
			filetype = {
				python = "python3 -u",
				cpp = "g++ $fileName -o $fileNameWithoutExt && ./$fileNameWithoutExt",
				c = "gcc $fileName -o $fileNameWithoutExt && ./$fileNameWithoutExt",
				java = "javac $fileName && java $fileNameWithoutExt",
				javascript = "node",
				typescript = "ts-node",
				rust = "cargo run",
				go = "go run",
				sh = "bash",
				dart = "flutter run",
			},
			project = {
				-- add project configs if needed
			},
		})

		-- with descriptions for which-key
		vim.keymap.set("n", "<leader>rr", ":RunCode<CR>", { desc = "Run Last Code", noremap = true, silent = false })
		vim.keymap.set("n", "<leader>rf", ":RunFile<CR>", { desc = "Run Current File", noremap = true, silent = false })
		vim.keymap.set(
			"n",
			"<leader>rft",
			":RunFile tab<CR>",
			{ desc = "Run File in Tab", noremap = true, silent = false }
		)
		vim.keymap.set("n", "<leader>rp", ":RunProject<CR>", { desc = "Run Project", noremap = true, silent = false })
		vim.keymap.set("n", "<leader>rc", ":RunClose<CR>", { desc = "Close Runner", noremap = true, silent = false })
		vim.keymap.set(
			"n",
			"<leader>crf",
			":CRFiletype<CR>",
			{ desc = "Show Filetype Command", noremap = true, silent = false }
		)
		vim.keymap.set(
			"n",
			"<leader>crp",
			":CRProjects<CR>",
			{ desc = "Show Projects List", noremap = true, silent = false }
		)
	end,
}