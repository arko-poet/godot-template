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


func update_bus_volume(bus_name: StringName, volume: float) -> void:
	assert(volume >= 0.0 and volume <= 1.0, "Volume values need to fall in range [0.0, 1.0].")
	
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volume_db = linear_to_db(volume)
	AudioServer.set_bus_volume_db(bus_index, volume_db)
	
	_save_setting("audio", bus_name, volume)


func _initialise_from_config() -> void:
	var config := ConfigFile.new()
	if not config.load(SETTINGS_PATH) == OK:
		return

	toggle_fullscreen(config.get_value("video", "fullscreen"))
	toggle_mute(config.get_value("audio", "mute"))
	
	for bus_index in AudioServer.bus_count:
		var bus_name := AudioServer.get_bus_name(bus_index)
		update_bus_volume(bus_name, config.get_value("audio", bus_name))


func _save_setting(section: String, key: String, value: Variant) -> void:
	var config := ConfigFile.new()
	config.load(SETTINGS_PATH)

	config.set_value(section, key, value)

	config.save(SETTINGS_PATH)
