require("global")

-- __DebugAdapter.print({ global.get_startup_setting("setting-name") })
-- __DebugAdapter.print({ global.get_global_setting("setting-name") })
-- __DebugAdapter.print({ global.get_player_setting(player_index, "setting-name") })

local mod_enabled = function (player_index)
  return global.get_player_setting(player_index, "enable")
end

-- game events
script.on_init(
  function ()
    global.console_open = {}
  end
)

-- sent chat/console message/command
script.on_event(
  {
    defines.events.on_console_chat,
    defines.events.on_console_command
  },
  function (e)
    if mod_enabled(e.player_index) then
      global.console_open[e.player_index] = false

      __DebugAdapter.print("> console submitted & closed")
    end
  end
)

-- opened console
script.on_event(
  global.event("input:open-console"),
  function (e)
    if mod_enabled(e.player_index) then
      global.console_open[e.player_index] = true

      __DebugAdapter.print("> console opened")
    end
  end
)

-- closed console
script.on_event(
  global.event("input:close-console"),
  function (e)
    if mod_enabled(e.player_index) then
      if global.console_open[e.player_index] == true then
        global.console_open[e.player_index] = false

        __DebugAdapter.print("> console closed")
      end
    end
  end
)

if script.active_mods["gvv"] then require("__gvv__.gvv")() end
