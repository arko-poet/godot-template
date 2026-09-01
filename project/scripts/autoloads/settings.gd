extends Node

const MIN_BUS_VOLUME := 0.0
const MAX_BUS_VOLUME := 1.0

const _SETTINGS_FILE_PATH := "user://settings.cfg"

const _DEFAULT_FULLSCREEN := false
const _DEFAULT_MUTE := false
const _DEFAULT_MASTER_BUS_VOLUME := 0.5 ## Master set to a half for accessability
const _DEFAULT_BUS_VOLUME := 1.0

var fullscreen: bool:
	set(value):
		fullscreen = value

		if fullscreen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

		_save_setting("video", "fullscreen", fullscreen)

var mute_enabled: bool:
	set(value):
		mute_enabled = value

		var bus_index := AudioServer.get_bus_index("Master")
		AudioServer.set_bus_mute(bus_index, mute_enabled)

		_save_setting("audio", "mute", mute_enabled)
var _bus_volumes: Dictionary[StringName, float]


func _ready() -> void:
	var config := ConfigFile.new()
	config.load(_SETTINGS_FILE_PATH)

	fullscreen = config.get_value("video", "fullscreen", _DEFAULT_FULLSCREEN)
	mute_enabled = config.get_value("audio", "mute", _DEFAULT_MUTE)

	for bus_index in AudioServer.bus_count:
		var bus_name := AudioServer.get_bus_name(bus_index)
		var default_bus_volume: float
		if bus_name == "Master":
			default_bus_volume = _DEFAULT_MASTER_BUS_VOLUME
		else:
			default_bus_volume = _DEFAULT_BUS_VOLUME
		set_bus_volume(bus_name, config.get_value("audio", bus_name.to_lower(), default_bus_volume))


func get_bus_volume(bus_name: StringName) -> float:
	if not bus_name in _bus_volumes:
		push_error("Bus with `%s` name does not exist." % bus_name)

	return _bus_volumes.get(bus_name, _DEFAULT_BUS_VOLUME)


func set_bus_volume(bus_name: StringName, volume: float) -> void:
	volume = minf(maxf(volume, MIN_BUS_VOLUME), MAX_BUS_VOLUME)

	var bus_index = AudioServer.get_bus_index(bus_name)
	if bus_index == -1:
		push_error("Bus with `%s` name does not exist." % bus_name)
		return
	AudioServer.set_bus_volume_linear(bus_index, volume)

	_bus_volumes[bus_name] = volume
	_save_setting("audio", bus_name.to_lower(), volume)


func _save_setting(section: String, key: String, value: Variant) -> void:
	var config := ConfigFile.new()
	config.load(_SETTINGS_FILE_PATH)
	config.set_value(section, key, value)
	config.save(_SETTINGS_FILE_PATH)
