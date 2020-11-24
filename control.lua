require("global")

-- __DebugAdapter.print({ global.get_startup_setting("setting-name") })
-- __DebugAdapter.print({ global.get_global_setting("setting-name") })
-- __DebugAdapter.print({ global.get_player_setting(player_index, "setting-name") })

if script.active_mods["gvv"] then require("__gvv__.gvv")() end
