-- helper class for vanilla changes (vanilla.lua)
local helper = {}

helper.upscaled_explosive_animation = function()
    return {
        {
          filename = "__base__/graphics/entity/bigass-explosion/hr-bigass-explosion-36f.png",
          flags = { "compressed" },
          animation_speed = 0.5,
          width = 324,
          height = 416,
          frame_count = 36,
          shift = util.by_pixel(0, -48),
          stripes =
          {
            {
              filename = "__base__/graphics/entity/bigass-explosion/hr-bigass-explosion-36f-1.png",
              width_in_frames = 6,
              height_in_frames = 3
            },
            {
              filename = "__base__/graphics/entity/bigass-explosion/hr-bigass-explosion-36f-2.png",
              width_in_frames = 6,
              height_in_frames = 3
            }
          }
        }
    }
end

helper.sound_range_multiplier = function(scalar)
    return
    {
      audible_distance_modifier = scalar,
      aggregation =
      {
        max_count = 1,
        remove = true
      },
      variations =
      {
        {
          filename = "__base__/sound/fight/large-explosion-1.ogg",
          volume = 1.0
        },
        {
          filename = "__base__/sound/fight/large-explosion-2.ogg",
          volume = 1.0
        }
      }
    }
end

return helper