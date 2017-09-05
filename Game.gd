extends Node

var background_data
var background_rect

onready var DebugLabel = get_node("/root/Game/UI/DebugLabel")
var debug_text

var debug = false
onready var MovementVisualizer = get_node("Spaceship/MovementVisualizer")

func _ready():
	set_process_input(true)
	set_pause_mode(PAUSE_MODE_PROCESS)

func _input(event):
	# Pause game
	if event.is_action_pressed("pause"):
		if get_tree().is_paused():
			get_tree().set_pause(false)
		else:
			get_tree().set_pause(true)
		
	# Toggle debug-info
	if event.is_action_pressed("debug"):
		debug = not debug
		MovementVisualizer.set("visibility/visible", debug)
		DebugLabel.set("visibility/visible", debug)
		
