helper = require("patches.vanilla-helper")

function load_patch()
    patch_rocket_missiles()
end

function patch_rocket_missiles()
    local entity = data.raw["explosion"]["explosion"]

    -- improve sound
    entity.sound = helper.sound_range_multiplier(5.0)

    -- increase explosion size
    entity.animations = helper.upscaled_explosive_animation()
end

load_patch()