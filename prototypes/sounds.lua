data:extend(
{
	{
		type     = "sound",
		name     = "lock-on",
		filename = "__JasonsTweaks__/sounds/lock-on.ogg",
		volume   = 0.42069,
		audible_distance_modifier = 1.0,
		aggregation =
		{
			max_count             = 1,
			remove                = true,
			count_already_playing = true
		}
    },
	{
		type     = "sound",
		name     = "missile-fire",
		filename = "__JasonsTweaks__/sounds/missile-fire.ogg",
		volume   = 0.69,
		audible_distance_modifier = 2.0,
		aggregation =
		{
			max_count             = 1,
			remove                = true,
			count_already_playing = true
		}
	},
	{
		type     = "sound",
		name     = "sonic-explosion-sound",
		filename = "__JasonsTweaks__/sounds/sonic-explosion.ogg",
		volume   = 1.5,
		audible_distance_modifier = 10.0,
	},
})
