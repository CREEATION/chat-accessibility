if type(global.set) == "nil" then require("global") end

-- features
local features = {
  background = require("features.background")
}

-- global.debug({ global.get_setting("startup", "setting-name") })
-- global.debug({ global.get_setting("global", "setting-name") })
-- global.debug({ global.get_setting("player", "setting-name", player_index) })

local has_console_open = function (player_index)
  return global.console_open[player_index]
end

local set_console_open = function (player_index, status)
  if type(status) == "nil" then
    status = true
  end

  if status == true then
    -- console open
    features.background.draw(player_index)
  else
    -- console closed
    features.background.destroy(player_index)
  end

  global.console_open[player_index] = status

  return global.console_open[player_index]
end

-- game events
script.on_init(
  function ()
    global.console_open = {}
    global.console_background = {}
    global.zoom_level = {}
  end
)

-- sent chat/console message/command
script.on_event(
  {
    defines.events.on_console_chat,
    defines.events.on_console_command,
  },
  function (e)
    if global.has_mod_enabled(e.player_index) then
      set_console_open(e.player_index, false)

      if type(e.message) == "string" then
        global.debug("> chat message sent & console closed")
      else
        global.debug("> command sent & console closed")
      end
    end
  end
)

-- opened console
script.on_event(
  global.event("input", "open-console"),
  function (e)
    if global.has_mod_enabled(e.player_index) then
      set_console_open(e.player_index)

      global.debug("> console opened")
    end
  end
)

-- closed console
script.on_event(
  global.event("input", "close-console"),
  function (e)
    if global.has_mod_enabled(e.player_index) then
      if has_console_open(e.player_index) then
        set_console_open(e.player_index, false)

        global.debug("> console closed")
      end
    end
  end
)

-- wants to destroy console background
script.on_event(
  global.event("input", "destroy-console-background"),
  function (e)
    if global.has_mod_enabled(e.player_index) then
      if has_console_open(e.player_index) then
        set_console_open(e.player_index, false)

        global.debug("> console background destroyed")
      end
    end
  end
)

-- zoomed in while console is open
script.on_event(
  global.event("input", "zoom-in"),
  function (e)
    if global.has_mod_enabled(e.player_index) then
      if has_console_open(e.player_index) then
        global.debug("> zoomed in")
      end
    end
  end
)

-- zoomed out while console is open
script.on_event(
  global.event("input", "zoom-out"),
  function (e)
    if global.has_mod_enabled(e.player_index) then
      if has_console_open(e.player_index) then
        global.debug("> zoomed out")
      end
    end
  end
)

if script.active_mods["gvv"] then require("__gvv__.gvv")() end
