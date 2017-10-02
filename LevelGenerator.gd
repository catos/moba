extends Node

onready var TileMap = get_node("/root/Game/TileMap")
onready var level_data = preload("res://level-2.png").get_data()

const STONE_COLOR = Color(0, 0, 0, 1)

func draw_level():
	for x in range(level_data.get_width()):
		for y in range(level_data.get_height()):
			var pixel = level_data.get_pixel(x, y)
			if pixel == STONE_COLOR:
				TileMap.set_cell(x, y, 0)
