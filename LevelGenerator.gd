extends Node

onready var tilemap = get_node("/root/Game/TileMap")
onready var level_data = preload("res://level-1.png").get_data()

const TRANSPARENT_COLOR = Color(0, 0, 0, 0)
const STONE_COLOR = Color(0, 0, 0, 1)

func draw_level():
	for x in range(level_data.get_width()):
		for y in range(level_data.get_height()):
			# Set block to use
			var block_id = 0
			
			# Get pixel from level_data
			var pixel = level_data.get_pixel(x, y)
			
			# If pixel above is transparent, use grass block
			if y > 0:
				var pixel_above = level_data.get_pixel(x, y - 1)
				if pixel_above == TRANSPARENT_COLOR:
					block_id = 2
				
			if pixel == STONE_COLOR:
				tilemap.set_cell(x, y, block_id)
