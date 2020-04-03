local helper = {}

--[[
    spawn targeting box
    @param surface the world
    @param entity the entity of target
    @param highlight_type
      available parameters:
       a. "electricity" (light-blue)
       b. "copy" (green)
       c. "not-allowed" (red)
       d. "entity" (yellow)
    @param duration
    @return highlight-box entity
--]]
function helper.render_target_box(surface, entity, highlight_type, duration)
    local box = entity.selection_box

    -- change render size based on entity type
    if entity.type == "unit" or entity.type == "car" then
        box = util.expand_box(entity.selection_box, 1.25)
    end
    
    return surface.create_entity {
        name = "highlight-box",
        position = entity.position,
        target = entity.position,
        bounding_box = box,
        blink_interval = 12,
        time_to_live = duration, -- default: 105
        box_type = highlight_type,
    }
end

--[[
    @param surface the world
    @param origin beginning position
    @param range units around origin
    @param force_type limit search to type (leave nil if no filter)
    @return a table of entities around the origin
--]]
function helper.get_entities(surface, origin, range, force_type)
    if force_type == nil then
        return surface.find_entities_filtered {
            position = origin,
            radius = range,
            collision_mask = {"object-layer", "player-layer"},
        }
    else
        return surface.find_entities_filtered {
            position = origin,
            radius = range,
            collision_mask = {"object-layer", "player-layer"},
            force = force_type,
        }
    end
end

--[[
    @param game global game
    @param sound_prototype_path 
]]
function helper.play_sound(game, sound_prototype_path, sound_position, volume)
    return game.play_sound {
        path = sound_prototype_path,
        position = sound_position,
        volume_modifier = volume
    }
end

-- -- returns an array of aircraft planes (as of 04/02/2020)
-- function helper.get_planes()
--     return {
--         "gunship",
--         "jet",
--         "flying-fortress",
--         "f22",
--         "b2",
--         "ac130"
--     }
-- end

return helper