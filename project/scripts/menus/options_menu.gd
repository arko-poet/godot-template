extends Node

@onready var tab_panels := [%VideoSettings, %AudioSettings, %GameSettings]

@onready var full_screen_button: CheckButton = %FullScreenButton

@onready var master_slider: HSlider = %MasterSlider
@onready var music_slider: HSlider = %MusicSlider
@onready var sfx_slider: HSlider = %SFXSlider
@onready var mute_button: CheckButton = %MuteButton


func _ready() -> void:
	var fullscreen_on = Settings.get_setting("video", "fullscreen")
	if fullscreen_on != null:
		full_screen_button.button_pressed = fullscreen_on

	var mute_enabled = Settings.get_setting("audio", "mute")
	if mute_enabled != null:
		mute_button.button_pressed = mute_enabled
		
	var master_bus_volume = Settings.get_setting("audio", "Master")
	if master_bus_volume != null:
		master_slider.value = master_bus_volume
	
	var music_bus_volume = Settings.get_setting("audio", "Music")
	if music_bus_volume != null:
		music_slider.value = music_bus_volume
		
	var sfx_bus_volume = Settings.get_setting("audio", "SFX")
	if sfx_bus_volume != null:
		sfx_slider.value = sfx_bus_volume


func _on_tab_bar_tab_changed(tab: int) -> void:
	for tab_index in tab_panels.size():
		var tab_panel: Control = tab_panels[tab_index]
		tab_panel.visible = tab_index == tab


func _on_accept_options_button_pressed() -> void:
	queue_free()


func _on_full_screen_button_toggled(toggled_on: bool) -> void:
	Settings.toggle_fullscreen(toggled_on)


func _on_mute_button_toggled(toggled_on: bool) -> void:
	Settings.toggle_mute(toggled_on)


func _on_master_slider_value_changed(value: float) -> void:
	Settings.update_bus_volume(&"Master", value)


func _on_music_slider_value_changed(value: float) -> void:
	Settings.update_bus_volume(&"Music", value)


func _on_sfx_slider_value_changed(value: float) -> void:
	Settings.update_bus_volume(&"SFX", value)
