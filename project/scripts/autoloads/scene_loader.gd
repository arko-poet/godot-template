extends Node

@export var main_menu_scene: PackedScene


func load_main_menu() -> void:
	print(get_tree().change_scene_to_packed(main_menu_scene))


func load_packed_scene(packed_scene: PackedScene) -> void:
	print(get_tree().change_scene_to_packed(packed_scene))
