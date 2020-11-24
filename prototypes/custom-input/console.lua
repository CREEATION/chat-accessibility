local _ = require("global")

data:extend(
  _.prototypes(
    -- properties applied to all prototypes
    {
      type = "custom-input",
      enabled_while_spectating = true,
      enabled_while_in_cutscene = true,
    },
    -- prototypes
    {
      {
        name = "open-console",
        linked_game_control = "toggle-console",
      },
      {
        name = "close-console",
        key_sequence = "ESCAPE",
        alternative_key_sequence = "GRAVE",
      },
    }
  )
)
