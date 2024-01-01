-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
	{
		-- transparent plugin
		'xiyaowong/transparent.nvim',
		-- transparent plugin panels
		extra_groups = {
			"NormalFloat", -- plugins which have float panel such as Lazy, Mason, LspInfo
			"NvimTreeNormal" -- NvimTree
		},
	},
	-- NightFox theme
	{ "EdenEast/nightfox.nvim" }, -- lazy

}
