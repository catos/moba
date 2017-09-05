extends Node

var background_data
var background_rect

onready var DebugLabel = get_node("/root/Game/DebugLabel")
var debug_text

var debug = false
onready var MovementVisualizer = get_node("Spaceship/MovementVisualizer")
onready var Spaceship = get_node("Spaceship")
onready var Background = get_node("Background")
onready var collision_pixel = Vector2(0, 16)

var explosion = preload("res://explosion.png")
var explosion_data
var explosion_size

func _ready():
	background_data = Background.get_texture().get_data()
	background_rect = background_data.get_used_rect()
	
	explosion_data = explosion.get_data()
	explosion_size = explosion.get_size()
	
	print(background_rect)
	print(Spaceship.get_pos())
	
	set_process(true)
	set_process_input(true)
	set_pause_mode(PAUSE_MODE_PROCESS)

func _process(delta):
	debug_text = ""

	if is_colliding_pixel():
#	if is_colliding_boxes():
		print("collision with background")
		Spaceship.set_linear_velocity(Vector2(0,0))
		Spaceship.set_gravity_scale(0)
	else:
		Spaceship.set_gravity_scale(1)
		
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

func _input(event):
	
	var data_modified = false
	if(event.type == InputEvent.MOUSE_BUTTON):
		var mouse_pos = get_global_mouse_pos() - Background.get_pos() - (explosion_size / 2)
		for x in range(0, explosion_size.width):
			for y in range(0, explosion_size.height):
				if explosion_data.get_pixel(x, y).a > 0 and background_rect.has_point(Vector2(mouse_pos.x + x, mouse_pos.y + y)):
					background_data.put_pixel(mouse_pos.x + x, mouse_pos.y + y, Color(0, 0, 0, 0))
					data_modified = true
	if data_modified:
		Background.get_texture().set_data(background_data)
	
	
	# MovementVisualizer
	MovementVisualizer.set("visibility/visible", true)
	# var pause_pressed = event.is_action_pressed("pause")
	# var debug_pressed = event.is_action_pressed("debug")
	# if pause_pressed:
	# 	if get_tree().is_paused():
	# 		get_tree().set_pause(false)
	# 	else:
	# 		get_tree().set_pause(true)
	# if debug_pressed:
	# 	debug = not debug
	# 	if debug:
	# 		MovementVisualizer.set("visibility/visible", false)
	# 	else:
	# 		MovementVisualizer.set("visibility/visible", true)