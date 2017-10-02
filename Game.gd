extends Node

var debug = false
var debug_text
onready var DebugLabel = get_node("/root/Game/UI/DebugLabel")
onready var MovementVisualizer = get_node("Spaceship/MovementVisualizer")

var Spaceship = preload("res://RigidSpaceship/Spaceship.tscn")

func _ready():
	print("Game _ready")
	LevelGenerator.draw_level()
	
	# Spawn player
	var spaceship = Spaceship.instance()
	add_child(spaceship)
	spaceship.set_pos(Vector2(64 * 16, 32 * 16))
	
	set_process(true)
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
		
