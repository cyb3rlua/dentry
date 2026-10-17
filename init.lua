---@class DesktopContent
---@field Name string  Specific name of the application, for example "Mozilla".
---@field Version? string
---@field Type "Application" | "Link" | "Directory"
---@field GenericName? string | "Web Browser" | "Media" | "Development"
---@field NoDisplay? boolean
---@field Comment? string
---@field Icon? string
---@field Hidden? boolean
---@field OnlyShowIn? string
---@field NotShowIn? string
---@field DBusActivatable? boolean
---@field TryExec? string
---@field Exec? string
---@field Path? string
---@field Terminal? boolean
---@field Actions? string | string[]
---@field MimeType? string[]
---@field Categories? string[]
---@field Implements? string[]
---@field Keywords? string[]
---@field StartupNotify? boolean
---@field StartupWMClass? string
---@field Url? string
---@field PrefersNonDefaultGPU? boolean
---@field SingleMainWindow? boolean

---@class DesktopMaker :DesktopContent
local DesktopMaker = {}
local keys = {
	"Name",
	"Version",
	"Type",
	"GenericName",
	"NoDisplay",
	"Comment",
	"Icon",
	"Hidden",
	"OnlyShowIn",
	"NotShowIn",
	"DBusActivatable",
	"TryExec",
	"Exec",
	"Path",
	"Terminal",
	"Actions",
	"MimeType",
	"Categories",
	"Implements",
	"Keywords",
	"StartupNotify",
	"StartupWMClass",
	"Url",
	"PrefersNonDefaultGPU",
	"SingleMainWindow",
}
local mtable = {}
mtable.__index = DesktopMaker
mtable.__metatable = "CALLL SECURITY!"
local PATHS = {
	USER = os.getenv "HOME" .. "/.local/share/applications",
	SYSTEM = "/usr/share/applications",
}

mtable.__pairs = function(tbl)
	local index = 0
	return function()
		index = index + 1
		local key = keys[index]
		if key then return key, tbl[key] end
	end,
		tbl,
		nil
end

---@param contents DesktopContent
---@return DesktopMaker
---@diagnostic disable-next-line: return-type-mismatch
function DesktopMaker.new(contents) return setmetatable(contents, mtable) end

---@param dir string | "USER" | "SYSTEM" Destination Directory, Defaults to USER ($HOME/.local/share/applications)
---@param name string | nil If not provided, will use ([self].Name):gsub('%s+', '')
---@return string
function DesktopMaker:write(dir, name)
	-- Remove trailing '/'
	dir = (PATHS[dir] or dir):gsub("%/+$", "")
	-- Replace whitespace in filename with '-'
	name = (name or self["Name"]):gsub("%s+", "-")
	-- append name to the directory to get a valid filepath
	local path = dir .. "/" .. name .. ".desktop"
	-- Open File
	local file <close>, err = io.open(path, "w+")
	if not file then
		error(("Unable to open file %s\n[ERROR]: %s"):format(path, err))
	end
	file:write(self:format())
	file:close()
	return path
end

function DesktopMaker:format()
	local fmtstr = { "[Desktop Entry]" }
	for _, kname in ipairs(keys) do
		local val = self[kname]
		if val == nil then goto continue end

		local val_str
		if type(val) == "table" then
			val_str = table.concat(val, ";") .. ";"
		else
			val_str = tostring(val)
		end

		table.insert(fmtstr, ("%s=%s"):format(kname, val_str))
		::continue::
	end
	return table.concat(fmtstr, "\n")
end

return DesktopMaker
