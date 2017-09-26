extends Node

var background_data
var background_rect

onready var DebugLabel = get_node("/root/Game/UI/DebugLabel")
var debug_text

var debug = false
onready var MovementVisualizer = get_node("Spaceship/MovementVisualizer")

var dirt_block = preload("res://DirtBlock.tscn")
var grass_block = preload("res://GrassBlock.tscn")

func _ready():
	# Draw dirt scene
	draw_dirt_island()
	
	set_process(true)
	set_process_input(true)
	set_pause_mode(PAUSE_MODE_PROCESS)

func draw_dirt_island():
	for i in range(10):
		var db = grass_block.instance()
		db.set_pos(Vector2(i * 16, 16 * 16))
		add_child(db)

	for i in range(8):
		var db = dirt_block.instance()
		db.set_pos(Vector2(i * 16 + 16, 16* 17))
		add_child(db)

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
		
