extends Node

const AUDIO_BUS_SLIDER_STEPS := 100

@onready var tab_panels := [%VideoSettings, %AudioSettings, %GameSettings]
@onready var audio_settings: GridContainer = %AudioSettings

@onready var full_screen_button: CheckButton = %FullScreenButton

@onready var mute_button: CheckButton = %MuteButton


func _ready() -> void:
	full_screen_button.button_pressed = Settings.fullscreen
	mute_button.button_pressed = Settings.mute_enabled

	for bus_index in AudioServer.bus_count:
		var bus_name := AudioServer.get_bus_name(bus_index)

		var bus_slider_label := Label.new()
		bus_slider_label.text = "%s:" % bus_name

		var bus_slider := HSlider.new()
		bus_slider.max_value = Settings.MAX_BUS_VOLUME
		bus_slider.step = Settings.MAX_BUS_VOLUME / AUDIO_BUS_SLIDER_STEPS
		bus_slider.value = Settings.get_bus_volume(bus_name)
		bus_slider.value_changed.connect(_on_bus_slider_value_changed.bind(bus_name))

		audio_settings.add_child(bus_slider_label)
		audio_settings.move_child(bus_slider_label, bus_index * 2)
		audio_settings.add_child(bus_slider)
		audio_settings.move_child(bus_slider, bus_index * 2 + 1)


func _on_tab_bar_tab_changed(tab: int) -> void:
	for tab_index in tab_panels.size():
		var tab_panel: Control = tab_panels[tab_index]
		tab_panel.visible = tab_index == tab


func _on_accept_options_button_pressed() -> void:
	queue_free()


func _on_full_screen_button_toggled(toggled_on: bool) -> void:
	Settings.fullscreen = toggled_on


func _on_mute_button_toggled(toggled_on: bool) -> void:
	Settings.mute_enabled = toggled_on


func _on_bus_slider_value_changed(value: float, bus_name: StringName) -> void:
	Settings.set_bus_volume(bus_name, value)
