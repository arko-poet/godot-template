extends Node


func _input(event):
	if event is InputEventKey and event.pressed:
		print(event)
