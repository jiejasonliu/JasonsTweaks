-- load only if Aircraft mod exists
function load_patch()
    if mods["Aircraft"] then
        patch_f22_guns_table()
    end
end

-- adds missiles to F22 guns table
function patch_f22_guns_table()
    local missiles_gun = "missile-launcher"

    -- verify in game
    if not data.raw["gun"][missiles_gun] then return end

    local f22_guns_table = data.raw["car"]["f22"].guns
    table.insert(f22_guns_table, missiles_gun)
end

load_patch()
