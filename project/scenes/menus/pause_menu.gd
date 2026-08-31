extends CanvasLayer

@export var options_menu_scene: PackedScene


func _ready() -> void:
	toggle_pause()


func _input(event: InputEvent) -> void:
	if event.is_action("ui_cancel") and event.is_pressed():
		get_viewport().set_input_as_handled()
		toggle_pause()


func toggle_pause() -> void:
	visible = not visible
	get_tree().paused = visible


func _on_options_button_pressed() -> void:
	var options_menu := options_menu_scene.instantiate()
	add_child(options_menu)


func _on_resume_button_pressed() -> void:
	toggle_pause()


func _on_main_menu_button_pressed() -> void:
	toggle_pause()
	SceneLoader.load_main_menu()


func _on_exit_button_pressed() -> void:
	get_tree().quit()
