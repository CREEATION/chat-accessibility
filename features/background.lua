if type(global.set) == "nil" then require("global") end

local _CHAT_BACKGROUND = {
  color = {
    r = 0.0,
    g = 0.0,
    b = 0.0,
    a = 0.69,
  }
}

_CHAT_BACKGROUND.get = function (player_index)
  return global.console_background[player_index]
end

_CHAT_BACKGROUND.destroy = function (player_index)
  if type(global.console_background[player_index]) == "number" then
    return rendering.destroy(global.console_background[player_index])
  end

  global.debug("[!] no chat background found to destroy for player " .. game.players[player_index].name)

  return false
end

_CHAT_BACKGROUND.draw = function (player_index)
  if global.console_open[player_index] then
    return
  end

  local render_target = game.players[player_index].character

  if type(render_target) == "nil" then
    return
  end

  if type(global.console_background) == "nil" then
    global.console_background = {}
  end

  local margin = 0.0
  local padding = 2.0
  local tile_px_size = 74
  local player_zoom = 1
  local display_resolution = render_target.player.display_resolution
  local display_width = math.ceil(display_resolution.width / tile_px_size) * player_zoom + padding
  local display_height = math.ceil(display_resolution.height / tile_px_size) * player_zoom + padding

  global.debug({
    display_resolution = table.concat({
      render_target.player.display_resolution.width,
      render_target.player.display_resolution.height,
    }, "x"),
    display_width = display_width,
    display_height = display_height,
  })

  local chat_rectangle = {
    {
      target = render_target,
      target_offset = {
        display_width - margin,
        display_height - margin
      }
    },
    {
      target = render_target,
      target_offset = {
        display_width - margin,
        -display_height + margin
      }
    },
    {
      target = render_target,
      target_offset = {
        -display_width + margin,
        display_height - margin
      }
    },
    {
      target = render_target,
      target_offset = {
        -display_width + margin,
        -display_height + margin
      }
    },
  }

  local render_console = rendering.draw_polygon(
    {
      color = _CHAT_BACKGROUND.color,
      vertices = chat_rectangle,
      target = render_target,
      draw_on_ground = false,
      surface = render_target.player.surface
    }
  )

  global.console_background[player_index] = render_console

  return render_console
end

return _CHAT_BACKGROUND
