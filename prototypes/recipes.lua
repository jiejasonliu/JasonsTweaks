data:extend({
    -- Missiles
    {
	type = "recipe",
	name = "missile-ammo",
	normal =
   	{
	enabled=true,
	energy_required=5,
	ingredients =
		{
			{"cluster-grenade", 1},
			{"explosive-rocket", 3}
		},
      result = "missile-ammo",
      result_count = 3,
   	},
  },
})