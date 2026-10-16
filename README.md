# lua-dentry

A lightweight, object-oriented Lua library for generating XDG-compliant Linux `.desktop` files. 

Creating `.desktop` files via scripts can be annoying, especially when dealing with formatting like `Categories` or `MimeType` that require specific semicolon formatting. 
`lua-dentry` handles the strict XDG formatting, key ordering, and array parsing for you.

## Installation with [Lux](https://codeberg.org/LuaLuxa):
```lua
{
    "cyb3rkun/lua-dentry",
    opts = { scope = "local" },
}
```

> Note: Lux and the LuaLuxa ecosystem are not yet publicly released. Manual installation is available in the meantime — just drop init.lua into your project.


# Usage 
Pass a standard Lua table to the constructor, and call :format() to generate the .desktop file string.

```lua
local Dentry = require "dentry" -- or whatever you named your init file

-- Create the desktop entry object
local entry = Dentry.new({
    Name = "Godot Engine",
    Type = "Application",
    GenericName = "Game Engine",
    Comment = "Multi-platform 2D and 3D game engine",
    Exec = "/home/user/Applications/Godot/godot.x86_64",
    Icon = "godot",
    Terminal = false,
    -- lua-dentry automatically formats Lua arrays into XDG-compliant semicolon strings!
    Categories = { "Development", "Game" } 
})

-- Generate the formatted string
local desktop_string = entry:format()

-- Write it to your local applications folder
local dest = os.getenv("HOME") .. "/.local/share/applications/godot.desktop"
local file <close> = assert(io.open(dest, "w+"))
file:write(desktop_string)
file:close()

-- dentry will eventually provide a function for writing to a file, to make ux easier,
-- and it will then automatically format, user will not need to call dentry:format()
-- but for now, simply writing manually works just fine.
```

The above code guarantees the keys are output in a clean, logical order, resulting in this perfectly formatted string:


```ini
[Desktop Entry]
Name=Godot Engine
Type=Application
GenericName=Game Engine
Comment=Multi-platform 2D and 3D game engine
Icon=godot
Exec=/home/user/Applications/Godot/godot.x86_64
Terminal=false
Categories=Development;Game;
```

# Supported Keys

lua-dentry strictly orders and supports the standard XDG Desktop Entry keys, including:
Name, Version, Type, GenericName, NoDisplay, Comment, Icon, Hidden, OnlyShowIn, NotShowIn, DBusActivatable, TryExec, Exec, Path, Terminal, Actions, MimeType, Categories, Implements, Keywords, StartupNotify, StartupWMClass, Url, PrefersNonDefaultGPU, SingleMainWindow.
