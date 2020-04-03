function register_futures() 
    --- makes a future time with an object
    -- futures : Dictionary (uint (tick) -> uint (player_index))
    if global.futures == nil then
        global.future = {}
    end
end

script.on_init(register_futures)
script.on_configuration_changed(register_futures)

-- table of players to check off
relevant_players = {}

-- player specific variables
local entities_currently_targeted = {}

--[[
    defines.events.on_trigger_created_entity()
    @param event
      > entity [LuaEntity] - entity that was spawned
      > source [LuaEntity] - entity that spawned it
]]
function fire_missile(event)
    -- verify entity
    if not event.entity and event.entity.valid then
        return
    end

    -- verify as a missile and originating from a vehicle
    if event.entity.name == "missile-launch" and event.source.type == "car" then
        local surface = event.entity.surface
        local projectile = settings.global["JasonsTweaks-rocket-type"].value
        local range = settings.global["JasonsTweaks-target-radius"].value
        local max_entities = settings.global["JasonsTweaks-max-target-count"].value
        local proj_per_entity = settings.global["JasonsTweaks-projectiles-per-entity"].value

        -- gather entities within cursor range
        local list_of_entities = helper.get_entities(surface, event.entity.position, range, "enemy")

        -- count how many entities we found
        local entity_count = surface.count_entities_filtered {
            position = event.entity.position,
            radius = range,
            collision_mask = {"object-layer", "player-layer"},
            force = "enemy",
            limit = max_entities
        }

        local player_id = nil

        for _, id in pairs(relevant_players) do
            if id == event.source.get_driver().player.index then
                player_id = id
            end
        end

        -- fire at each entity
        if player_id ~= nil and entities_currently_targeted[player_id] ~= nil then
            for _, entity in pairs(entities_currently_targeted[player_id]) do
                if entity.valid then
                    local adjusted_speed = nil

                    -- adjust missile speed depending type of entity
                    if entity.type == "unit-spawner" then
                        adjusted_speed = math.random(0.45, 0.65)
                    else
                        adjusted_speed = math.random(1.0, 1.5)
                    end

                    -- spawn extra stacked projectiles per entity targeted
                    for i=1,proj_per_entity do
                        -- play explosion and artifically damage if is a car
                        if entity ~= nil and entity.type ~= nil and entity.type == "car" then
                            surface.create_entity {
                                name = "non-explosive-rocket",
                                target = entity.position,
                                position = event.source.position,
                                speed = math.random(1.5, 2.0),
                                max_range = 180 + range,
                            }
                            -- futures for explosion & damage
                            local distance = util.vectors_delta_length(entity.position, event.source.position)
                            global.future[event.tick + math.floor((60 * (4.5 * ((distance + 1) / 500))))] = entity
                        -- otherwise, create regular projectile
                        else
                            surface.create_entity {
                                name = projectile,
                                target = entity.position,
                                position = event.source.position,
                                speed = adjusted_speed,
                                max_range = 180 + range,
                            }
                        end

                    end
                end
            end
        end

        -- extra entities to be fired at
        local limited_unique_extra_entities = {}

        -- pardon filter if no enemy entities targeted (let it shoot trees and rocks)
        if entity_count == 0 then
            local extra_entities = helper.get_entities(surface, event.entity.position, range, nil)

            local unique_extra_entities = {}
            for _, entity in pairs(extra_entities) do
                if list_of_entities[entity] == nil then
                    table.insert(unique_extra_entities, entity)
                end
            end

            -- custom comparator for non-enemy entities
            local function sort_by_proximity(e1, e2)
                local pos = event.entity.position

                return util.vectors_delta_length(e1.position, pos) < util.vectors_delta_length(e2.position, pos)
            end

            table.sort(unique_extra_entities, sort_by_proximity)
            
            limited_unique_extra_entities = util.limit_table(unique_extra_entities, 1, math.random(max_entities / 2, max_entities))

            -- fire at each new entity
            for _, entity in pairs(limited_unique_extra_entities) do
                -- mandatory filter
                if entity.valid and entity.type ~= "cliff" then
                    surface.create_entity {
                        name = projectile,
                        target = entity.position,
                        position = event.source.position,
                        speed = math.random(0.05, 0.50),
                        max_range = 180 + range,
                    }

                    if player_id ~= nil then
                        local color = settings.get_player_settings(game.get_player(player_id))["JasonsTweaks-target-color"].value
                        helper.render_target_box(surface, entity, color, 105)
                    else
                        helper.render_target_box(surface, entity, "copy", 105)
                    end
                end
            end
        end 

        -- give back ammo if no entities targeted
        if util.get_table_size(entities_currently_targeted) == 0 and util.get_table_size(limited_unique_extra_entities) == 0 then
            event.source.insert({
                name = "missile-ammo",
                count = 1,
            })
        else
            helper.play_sound(game, "missile-fire", event.source.position, 1.0)
            -- reset highlighted_list
            if entities_currently_targeted[player_id] ~= nil then
                table.remove(entities_currently_targeted, player_id)
            end
        end

    end
end


--[[
    defines.events.on_select_entity_changed()
    @param event
      > player_index [uint]
      > last_entity [LuaEntity] (can be nil)
]]
function assign_missile_lock_on(event)
    local id = event.player_index
    local player = game.players[event.player_index]

    --- remove only when conditions arise
    -- remove after 2.5 seconds only after 
    if event.last_entity ~= nil and event.last_entity.type ~= "unit" and event.last_entity.type ~= "car" then
        -- clear target list(s)
        if entities_currently_targeted[id] ~= nil then
            table.remove(entities_currently_targeted, id)
        end

        if relevant_players[id] ~= nil then
            table.remove(relevant_players, id)
        end
    else
        if player.selected == nil then
            -- delete the targeted entities after 2.5 seconds
            local seconds = 3.0
            global.future[event.tick + (60 * 2.5)] = id
        end
    end

    if (player.vehicle ~= nil and player.vehicle.name == "f22" and player.vehicle.selected_gun_index == 5) and player.selected ~= nil then
        local entities_to_target = helper.get_entities(player.surface, player.selected.position, settings.global["JasonsTweaks-target-radius"].value, "enemy")

        -- enable dogfight (all cars)
        if settings.global["JasonsTweaks-dogfight"].value then
            local dogfight = player.surface.find_entities_filtered {
                position = player.selected.position,
                radius = settings.global["JasonsTweaks-target-radius"].value,
                type = "car"
            }

            for _, entity in pairs(dogfight) do
                if entity ~= player.vehicle then
                    table.insert(entities_to_target, entity)
                end
            end
        end

        local target_position = player.selected.position

        -- custom comparator function
        local function sort_by_proximity(e1, e2)
            return util.vectors_delta_length(e1.position, target_position) < util.vectors_delta_length(e2.position, target_position)
        end

        -- sort by proximity to target location
        table.sort(entities_to_target, sort_by_proximity)

        local limited_entities_to_target = util.limit_table(entities_to_target, 1, settings.global["JasonsTweaks-max-target-count"].value)

        entities_currently_targeted[event.player_index] = limited_entities_to_target

        -- clear all future missile clears for player if a new entity is hovered
        local future_table = global.future
        for tick = event.tick, (event.tick + (60 * 2.5)) do
            local tick_entry = future_table[tick]
            if tick_entry ~= nil and tick_entry == id then
                global.future[tick] = nil
            end
        end

        -- update relevant players
        table.insert(relevant_players, id)
    end
end
    
-- add to global on_game_tick()
function draw_missile_lock_on(event)
    local duration = 12

    if event.tick % duration == 0 then
        for _, id in pairs(relevant_players) do
            if entities_currently_targeted[id] ~= nil then
                for _, entity in pairs(entities_currently_targeted[id]) do
                    if entity.valid then
                        local color = settings.get_player_settings(game.get_player(id))["JasonsTweaks-target-color"].value
                        helper.render_target_box(entity.surface, entity, color, duration)
                    end
                end
            end
        end
    end
end

-- add to global on_game_tick()
function play_missile_lock_on(event)
    local duration = 18
    local reference = nil
    local empty = true

    if event.tick % duration == 0 then
        for _, id in pairs(relevant_players) do
            if entities_currently_targeted[id] ~= nil then
                for _, entity in pairs(entities_currently_targeted[id]) do
                    reference = entity
                    empty = false
                    break
                end
            end

            if not empty then
                helper.play_sound(game, "lock-on", game.players[id].position, 1.0)
            end
        end
    end
end

--- add to global on_game_tick()
-- future [tick] -> [player_id]
function timed_clear_missile_lock_on(event)
    -- terminate if no data
    local next = next
    local future_table = global.future
    if next(future_table) == nil then return end
    
    -- clear lock on attached to player id (table entry that is the tick to perform)
    if global.future[event.tick] then
        local id = global.future[event.tick]
        if entities_currently_targeted[id] ~= nil then
            table.remove(entities_currently_targeted, id)
            global.future[event.tick] = nil
        end
    end
end

--- add to global on_game_tick()
-- future [tick] -> [not a number; LuaEntity]
function delayed_artificial_missile_hit(event)
    -- terminate if no data
    local next = next
    local future_table = global.future
    if next(future_table) == nil then 
        return 
    end

    -- clear lock on attached to player id (table entry that is the tick to perform)
    if global.future[event.tick] then
        local entity = global.future[event.tick]

        -- do not do unless futures table contains a LuaEntity reference
        if type(entity) == "number" then return end

        if entity.valid then
            local render = rendering.draw_animation {
                animation = "sonic-explosion",
                render_layer = "light-effect",
                target = entity.position,
                surface = entity.surface,
                time_to_live = 60, --was 64
                animation_speed = 0.5,
            }

            helper.play_sound(game, "sonic-explosion-sound", entity.position, 1.0)
            entity.damage(420, "enemy", "explosion")
        end

        global.future[event.tick] = nil
    end
end

-- global driver for defines.events.on_tick()
function on_game_tick(event)
    -- update_game_settings(event)
    draw_missile_lock_on(event)
    play_missile_lock_on(event)
    timed_clear_missile_lock_on(event)
    delayed_artificial_missile_hit(event)
end

-- add events to event handler
script.on_event(defines.events.on_trigger_created_entity, fire_missile)
script.on_event(defines.events.on_selected_entity_changed, assign_missile_lock_on)
script.on_event(defines.events.on_tick, on_game_tick)