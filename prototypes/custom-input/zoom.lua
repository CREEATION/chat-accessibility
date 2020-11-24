local _ = require("global")

data:extend(
  _.prototypes(
    -- properties applied to all prototypes
    {
      type = "custom-input",
    },
    -- prototypes
    {
      {
        name = "zoom-in",
        linked_game_control = "zoom-in"
      },
      {
        name = "zoom-out",
        linked_game_control = "zoom-out"
      },
    }
  )
)
