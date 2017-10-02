onready var TileMap = get_node("/root/Game/TileMap")
onready var level = preload("res://level-2.png")

const STONE_COLOR = Color(0, 0, 0, 1)

var level_data

func _ready():
	print("LevelGenerator _ready")
	level_data = level.get_data()
	
func draw_level():
	for x in range(level_data.get_width()):
		for y in range(level_data.get_height()):
			var pixel = level_data.get_pixel(x, y)
			if pixel == STONE_COLOR:
				TileMap.set_cell(x, y, 0)
	
func draw_islands():
	for i in range(4):
		var rnd1 = floor(rand_range(-64, 64))
		var rnd2 = floor(rand_range(-64, 64))
		draw_dirt_island(rnd1, rnd2)
	
func draw_dirt_island(pos_x, pos_y):
	var offset_x = pos_x * 16
	var offset_y = pos_y * 16
	
	for i in range(10):
		TileMap.set_cell(pos_x + i, pos_y, 2)

	for i in range(8):
		TileMap.set_cell(pos_x + i + 1, pos_y + 1, 1)