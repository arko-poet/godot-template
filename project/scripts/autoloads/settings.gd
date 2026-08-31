extends Node

const SETTINGS_PATH := "user://settings.cfg"


func _ready() -> void:
	_initialise_from_config()


func get_setting(section: String, key: String) -> Variant:
	var config := ConfigFile.new()
	config.load(SETTINGS_PATH)
	if not config.load(SETTINGS_PATH) == OK:
		return

	return config.get_value(section, key)


func toggle_fullscreen(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

	_save_setting("video", "fullscreen", toggled_on)


func toggle_mute(enable: bool) -> void:
	var bus_index := AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(bus_index, enable)

	_save_setting("audio", "mute", enable)


func _initialise_from_config() -> void:
	var config := ConfigFile.new()
	if not config.load(SETTINGS_PATH) == OK:
		return

	toggle_fullscreen(config.get_value("video", "fullscreen"))
	toggle_mute(config.get_value("audio", "mute"))


func _save_setting(section: String, key: String, value: Variant) -> void:
	var config := ConfigFile.new()
	config.load(SETTINGS_PATH)

	config.set_value(section, key, value)

	config.save(SETTINGS_PATH)
