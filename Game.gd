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
	draw_islands()
	
	set_process(true)
	set_process_input(true)
	set_pause_mode(PAUSE_MODE_PROCESS)

func draw_islands():
	for i in range(16):
		var rnd1 = floor(rand_range(-64, 64))
		var rnd2 = floor(rand_range(-64, 64))
		print(str(rnd1) + ", " + str(rnd2))
		draw_dirt_island(rnd1, rnd2)
	
func draw_dirt_island(pos_x, pos_y):
	var offset_x = pos_x * 16
	var offset_y = pos_y * 16
	
	for i in range(10):
		var db = grass_block.instance()
		db.set_pos(Vector2(i * 16 + offset_x, 16 + offset_y))
		add_child(db)

	for i in range(8):
		var db = dirt_block.instance()
		db.set_pos(Vector2(i * 16 + 16 + offset_x, 16 + 16 + offset_y))
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
		
