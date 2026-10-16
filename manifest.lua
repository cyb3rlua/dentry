---@type LuxManifest
return {
	name = "dentry",
	namespace = "luxa.dentry",
	license = {
		spdx = "MIT",
		files = { "LICENSE" },
	},
	lua_modules = {
		{
			name = "dentry",
			sources = { "init.lua" },
		},
	},
}
