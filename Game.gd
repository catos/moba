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
	background_data = Background.get_texture().get_data()
	background_rect = background_data.get_used_rect()
	
	explosion_data = explosion.get_data()
	explosion_size = explosion.get_size()
	
	print(background_rect)
	print(Spaceship.get_pos())
	
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

func _process(delta):
	debug_text = ""

#	if is_colliding_pixel():
#	if is_colliding_boxes():
#		print("collision with background")
#		Spaceship.set_linear_velocity(Vector2(0,0))
#		Spaceship.set_gravity_scale(0)
#	else:
#		Spaceship.set_gravity_scale(1)
		
	DebugLabel.set_text(debug_text)

func is_colliding_boxes():
#	var spaceship_rect = Spaceship.get_node("CollisionShape2D").get_item_rect()
#	debug_text += "spaceship_rect: " + str(spaceship_rect) + "\n"
#
#	if background_rect.intersects(spaceship_rect):
#		debug_text += "intersects!\n"
		background_data.get_data()

func is_colliding_pixel():
	# settup transparent color
	var c = Color(0, 0, 0, 0) 
	
	# normalize pixel position for texture checking
	var pixel_pos = Spaceship.get_pos() + collision_pixel - Background.get_pos() 
	
	# if our collision pixel on background, check it's value
	if background_rect.has_point(pixel_pos):
		c = background_data.get_pixel(pixel_pos.x, pixel_pos.y) 

	# if it's not transparent, we have collision!
	return c.a != 0

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
		
