extends Control

var paused = false

func _ready():
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("ui_accept"):
		paused = not paused
		get_tree().set_pause(paused)
