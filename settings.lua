data:extend(
{
    -- startup
    {
        type = "int-setting",
        name = "JasonsTweaks-arbitary",
        setting_type = "startup",
        default_value = 0
    },

    -- global
	{
		type = "string-setting",
		name = "JasonsTweaks-rocket-type",
		setting_type = "runtime-global",
        default_value = "explosive-rocket",
        allowed_values = {"rocket", "explosive-rocket", "heavy-explosive-rocket-projectile"},
		order = "a-a",
    },
    {
		type = "int-setting",
		name = "JasonsTweaks-target-radius",
		setting_type = "runtime-global",
        default_value = 16,
        allowed_values = {16, 24, 32, 40, 48, 56, 64},
		order = "a-b",
	},
    {
        type = "int-setting",
        name = "JasonsTweaks-max-target-count",
        setting_type = "runtime-global",
        default_value = 5,
        minimum_value = 1,
        maximum_value = 20,
        order = "a-c",
    },
	{
		type = "int-setting",
		name = "JasonsTweaks-projectiles-per-entity",
		setting_type = "runtime-global",
        default_value = 3,
        minimum_value = 1,
        maximum_value = 10,
		order = "a-d",
    },
    {
        type = "bool-setting",
        name = "JasonsTweaks-dogfight",
        setting_type = "runtime-global",
        default_value = true,
        allowed_values = {true, false},
        order = "a-e",
    },

    -- per player
    {
		type = "string-setting",
		name = "JasonsTweaks-target-color",
		setting_type = "runtime-per-user",
        default_value = "copy",
        allowed_values = {"electricity", "copy", "not-allowed", "entity"},
		order = "a-a",
    },
    {
		type = "bool-setting",
		name = "JasonsTweaks-plane-zoom-enabled",
		setting_type = "runtime-per-user",
        default_value = true,
        allowed_values = {true, false},
		order = "a-b",
    },
    {
		type = "double-setting",
		name = "JasonsTweaks-plane-zoom",
		setting_type = "runtime-per-user",
        default_value = 0.175,
        allowed_values = {0.125, 0.150, 0.175, 0.200, 0.225},
		order = "a-c",
    },
})