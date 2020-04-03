data:extend({
  -- add missiles category
  {
    type = "ammo-category",
    name = "missiles",
    bonus_gui_order = "x-d"
  },

  -- add missiles launch (entity) category
  {
    type = "explosion",
    name = "missile-launch",
    animations = {
      {
        direction_count = 1,
        filename = "__core__/graphics/clear.png",
        frame_count = 1,
        height = 1,
        line_length = 1,
        width = 1
      }
    },
    flags = {
      "not-on-map", "placeable-off-grid"
    },
  },

  -- missiles
  {
    type = "ammo",
    name = "missile-ammo",
    ammo_type = 
    {
      category = "missiles",
      target_type = "direction",
      action = 
      {
        {
          type = "direct",
          action_delivery =
          {
            type = "instant",
            target_effects = 
            {
              {
                type = "create-entity",
                entity_name = "missile-launch",
                trigger_created_entity = true,
                show_in_tooltip = false,
              },
              {
                action = 
                {
                  action_delivery = 
                  {
                    target_effects = 
                    {
                      {
                        damage = 
                        {
                          amount = 0,
                          type = "explosion"
                        },
                        type = "damage"
                      },
                    },
                    type = "instant"
                  },
                  radius = 16,
                  force = "enemy",
                  type = "area"
                },
                type = "nested-result"
              },
            }
          }
        }
      }
    },
    icon = "__base__/graphics/icons/rocket.png",
    icon_size = 64,
    magazine_size = 1,
    order = "z-t[missiles]",
    stack_size = 100,
    subgroup = "ammo",
    order = "v[missile-ammo]",
    stack_size = 100
  },

  -- missile launcher
  { 
    type = "gun",
    name = "missile-launcher",
    icon = "__base__/graphics/icons/rocket-launcher.png",
    icon_size = 64,
    flags = {"hidden"},
    subgroup = "gun",
    order = "y[missile-launcher]",
    attack_parameters =
    {
      type = "projectile",
      ammo_category = "missiles",
      movement_slow_down_factor = 0.5,
      cooldown = 150,
      projectile_creation_distance = 0.6,
      range = 90,
      projectile_center = {-0.17, 0},
      sound =
      {
        {
          filename = "__JasonsTweaks__/sounds/missile-fire.ogg",
          volume = 0.0
        }
      }
    },
    stack_size = 1
  }
  -- more
})