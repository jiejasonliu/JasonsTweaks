function zoom_in_plane(event) 
    local player = game.players[event.player_index]
    local vehicle = player.vehicle

    -- whether custom zoom is enabled
    if settings.get_player_settings(player)["JasonsTweaks-plane-zoom-enabled"].value then
    -- is a vehicle in Aircraft
        if vehicle ~= nil and vehicle.prototype.collision_mask["layer-15"] then
            player.zoom = settings.get_player_settings(player)["JasonsTweaks-plane-zoom"].value
        end

        -- not in any vehicle (reset zoom)
        if player.vehicle == nil then
            player.zoom = 0.420
        end
    end

end

script.on_event(defines.events.on_player_driving_changed_state, zoom_in_plane)