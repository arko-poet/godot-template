extends Node

var elapsed_time := 0.0:
	set(value):
		elapsed_time = value
		elapsed_time_label.text = "%.1fs" % elapsed_time

var count := 0:
	set(value):
		count = value
		counter_label.text = str(count)

@onready var elapsed_time_label: Label = %ElapsedTimeLabel
@onready var counter_label: Label = %CounterLabel


func _process(delta: float) -> void:
	elapsed_time += delta


func _on_counter_button_pressed() -> void:
	count += 1
