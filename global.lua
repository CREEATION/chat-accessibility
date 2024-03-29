local _GLOBAL = {
  set = true,
  mod = {
    debug = true,
    namespace = "c7",
    name = "chat-accessibility",
    sep = ":",
    prototypes = {
      types_names = {
        ["custom-input"] = "input",
      },
    },
    settings = {
      types_names = {
        ["startup"] = "startup",
        ["runtime-global"] = "global",
        ["runtime-per-user"] = "player",
      },
      default_values = {
        ["bool-setting"] = false,
        ["int-setting"] = 0,
        ["double-setting"] = 0.0,
        ["string-setting"] = "",
      },
      default_order = "a",
    },
  }
}

_GLOBAL.debug = function (value)
  if _GLOBAL.mod.debug == true then
    __DebugAdapter.print(value)
  end
end

_GLOBAL.has_mod_enabled = function (player_index)
  return _GLOBAL.get_setting("player", "enable", player_index)
end

_GLOBAL.get_setting = function (setting_type, name, player_index)
  if setting_type == "player" and type(player_index) == "number" then
    return game.players[player_index].mod_settings[_GLOBAL.setting_name(name, "runtime-per-user")]
  end

  setting_type = _GLOBAL.mod.settings.types_names[setting_type]

  return settings[setting_type][_GLOBAL.setting_name(name, setting_type)].value
end

_GLOBAL.set_setting = function (setting_type, name, value, player_index)
  if setting_type == "player" and type(player_index) == "number" then
    game.players[player_index].mod_settings[_GLOBAL.setting_name(name, "runtime-per-user")] = value

    return _GLOBAL.get_setting(setting_type, name, player_index)
  end

  setting_type = _GLOBAL.mod.settings.types_names[setting_type]

  settings[setting_type][_GLOBAL.setting_name(name, setting_type)] = value

  return _GLOBAL.get_setting(setting_type, name, player_index)
end

_GLOBAL._name = function (name, type, label)
  local mod = _GLOBAL.mod

  return table.concat({
    mod.namespace,
    mod.name,
    label,
    mod[label].types_names[type],
    name
  }, mod.sep)
end

_GLOBAL.prototype_name = function (name, type)
  return _GLOBAL._name(name, type, "prototypes")
end

_GLOBAL.setting_name = function (name, type)
  return _GLOBAL._name(name, type, "settings")
end

_GLOBAL.setting_default_value = function (setting)
  local mod = _GLOBAL.mod

  -- skip setting default value if there's already one set
  for property, _ in pairs(setting) do
    if property == "default_value" then
      return setting
    end
  end

  for property, setting_type in pairs(setting) do
    if property == "type" then
      setting.default_value = mod.settings.default_values[setting_type]
    end
  end

  return setting
end

_GLOBAL.setting_localise = function (setting)
  local mod = _GLOBAL.mod
  local localised_setting_name = table.concat({
    mod.namespace,
    mod.name,
    setting.name
  }, mod.sep)

  setting.localised_name = {
    table.concat({
      "mod-setting-name",
      localised_setting_name
    }, ".")
  }

  -- apply richtext formatting to setting if set
  setting = _GLOBAL.setting_richtext(setting)

  setting.localised_description = {
    table.concat({
      "mod-setting-description",
      localised_setting_name
    }, ".")
  }

  return setting
end

_GLOBAL.setting_order = function(setting)
  local mod = _GLOBAL.mod

  if type(setting.order) == "nil" then
    setting.order = mod.settings.default_order
  end

  return setting
end

--@TODO: yikes
_GLOBAL.setting_richtext = function(setting)
  local richtext_format = function(type, property, str)
    if type == "start" then
      return string.format("[" .. property .. "=%s]%s", setting[property], str)
    end

    return string.format("%s[/" .. property .. "]", str)
  end

  local richtext_start = ""
  local richtext_end = ""

  if not(type(setting.color) == "nil") then
    richtext_start = richtext_format("start", "color", richtext_start)
    richtext_end = richtext_format("end", "color", richtext_end)
  end

  if not(type(setting.font) == "nil") then
    richtext_start = richtext_format("start", "font", richtext_start)
    richtext_end = richtext_format("end", "font", richtext_end)
  end

  setting.localised_name = {
    setting.localised_name[1],
    richtext_start,
    richtext_end
  }

  -- remove non-standard "color" and "font" properties
  setting.color = nil
  setting.font = nil

  return setting
end

_GLOBAL.settings = function (global_properties, settings)
  -- set global properties & normalize default values
  for global_property, global_value in pairs(global_properties) do
    for i, _ in pairs(settings) do
      settings[i][global_property] = global_value
    end
  end

  -- transform setting
  for i, _ in pairs(settings) do
    -- set localise strings (name and description)
    settings[i] = _GLOBAL.setting_localise(settings[i])

    -- set default value if there's none set already
    settings[i] = _GLOBAL.setting_default_value(settings[i])

    -- set default order if there's none set already
    settings[i] = _GLOBAL.setting_order(settings[i])

    for property, value in pairs(settings[i]) do
      -- set setting name according to mod settings
      if property == "name" then
        settings[i].name = _GLOBAL.setting_name(value, settings[i].setting_type)
      end
    end
  end

  return settings
end

_GLOBAL.prototypes = function (global_properties, prototypes)
  -- set global properties & normalize default values
  for global_property, global_value in pairs(global_properties) do
    for i, _ in pairs(prototypes) do
      prototypes[i][global_property] = global_value
    end
  end

  -- transform prototype
  for i, prototype in ipairs(prototypes) do
    for property, value in pairs(prototypes[i]) do
      -- set prototype name according to mod prototypes
      if property == "name" then
        prototypes[i].name = _GLOBAL.prototype_name(value, prototypes[i].type)
      end
    end

    -- set key_sequence if not already set and type is "custom-input"
    if prototype.type == "custom-input" then
      if type(prototype.key_sequence) == "nil" then
        prototypes[i].key_sequence = ""
      end
    end
  end

  return prototypes
end

_GLOBAL.event = function (event_type, event_name)
  local mod = _GLOBAL.mod

  return table.concat({
    mod.namespace,
    mod.name,
    "prototypes",
    event_type,
    event_name
  }, mod.sep)
end

if type(global) == "nil" then
  return _GLOBAL
end

for key, value in pairs(_GLOBAL) do
  global[key] = value
end
