extends Node

var background_data
var background_rect

var debug = false
var debug_text
onready var DebugLabel = get_node("/root/Game/UI/DebugLabel")
onready var MovementVisualizer = get_node("Spaceship/MovementVisualizer")

var Spaceship = preload("res://RigidSpaceship/Spaceship.tscn")

var StoneBlock = preload("res://StoneBlock.tscn")
var DirtBlock = preload("res://DirtBlock.tscn")
var GrassBlock = preload("res://GrassBlock.tscn")

var level_1 = preload("res://level-1.png")
var level_1_data
const STONE_COLOR = Color(0, 0, 0, 1)

func _ready():
	
	# Load level image
	level_1_data = level_1.get_data()
	var c = level_1_data.get_pixel(1, 1)
	print(str(c))
	
	# Draw dirt scene
	draw_level(level_1_data)
#	draw_islands()
	
	var spaceship = Spaceship.instance()
	add_child(spaceship)
	spaceship.set_pos(Vector2(64 * 16, 32 * 16))
	
	
	set_process(true)
	set_process_input(true)
	set_pause_mode(PAUSE_MODE_PROCESS)

func draw_level(level_data):
	for x in range(level_data.get_width()):
		for y in range(level_data.get_height()):
			var pixel = level_data.get_pixel(x, y)
			if pixel == STONE_COLOR:
				var sb = StoneBlock.instance()
				add_child(sb)
				sb.set_pos(Vector2(x * 16, y * 16))
	
func draw_islands():
	for i in range(16):
		var rnd1 = floor(rand_range(-64, 64))
		var rnd2 = floor(rand_range(-64, 64))
		draw_dirt_island(rnd1, rnd2)
	
func draw_dirt_island(pos_x, pos_y):
	var offset_x = pos_x * 16
	var offset_y = pos_y * 16
	
	for i in range(10):
		var db = GrassBlock.instance()
		db.set_pos(Vector2(i * 16 + offset_x, 16 + offset_y))
		add_child(db)

	for i in range(8):
		var db = DirtBlock.instance()
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
		
