extends Node

@export var ui_hover_sound: AudioStream
@export var ui_pressed_sound: AudioStream


func _enter_tree() -> void:
	get_tree().node_added.connect(_on_node_entered_tree)


func _on_node_entered_tree(node: Node) -> void:
	if node is Button:
		node.mouse_entered.connect(_on_mouse_entered)
		node.pressed.connect(_on_node_pressed)


func _on_mouse_entered() -> void:
	var audio_stream_player := AudioStreamPlayer.new()
	audio_stream_player.stream = ui_hover_sound
	audio_stream_player.bus = &"SFX"
	add_child(audio_stream_player)
	audio_stream_player.play()
	audio_stream_player.finished.connect(audio_stream_player.queue_free)


func _on_node_pressed() -> void:
	var audio_stream_player := AudioStreamPlayer.new()
	audio_stream_player.stream = ui_pressed_sound
	audio_stream_player.bus = &"SFX"
	add_child(audio_stream_player)
	audio_stream_player.play()
	audio_stream_player.finished.connect(audio_stream_player.queue_free)
