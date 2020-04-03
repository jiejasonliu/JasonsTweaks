local sprites_path = "__JasonsTweaks__/graphics/entities/explosions/"

data:extend({
    {
        type = "animation",
        name = "sonic-explosion",
        filename = sprites_path .. "sonic-explosion.png",
        flags = { "compressed" },
        width = 394,
        height = 490,
        frame_count = 30,
        line_length = 6,
        -- shift = {0.1875, -0.75},
        animation_speed = 1.0
    }
})