extends Node

@onready var tab_panels := [%VideoSettings, %AudioSettings, %GameSettings]
@onready var full_screen_button: CheckButton = %FullScreenButton


func _ready() -> void:
	var fullscreen_on = Settings.get_setting("video", "fullscreen")
	if fullscreen_on == null:
		return
		
	full_screen_button.button_pressed = fullscreen_on


func _on_tab_bar_tab_changed(tab: int) -> void:
	for tab_index in tab_panels.size():
		var tab_panel: Control = tab_panels[tab_index]
		if tab_index == tab:
			tab_panel.show()
		else:
			tab_panel.hide()


func _on_accept_options_button_pressed() -> void:
	queue_free()


func _on_full_screen_button_toggled(toggled_on: bool) -> void:
	Settings.toggle_fullscreen(toggled_on)
