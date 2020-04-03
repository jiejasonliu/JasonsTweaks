-- mandatory loads
require("prototypes.items")
require("prototypes.entities")
require("prototypes.recipes")
require("prototypes.sounds")
require("prototypes.animations")

-- patch mods
local patch = "patches/"
require(patch .. "vanilla")
require(patch .. "aircraft")