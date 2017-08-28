extends RigidBody2D

export var thruster_power = 250

onready var rotation = get_rot()

var direction = Vector2()
var thrust = Vector2(0, 1)

onready var DebugLabel = get_node("/root/Game/DebugLabel")
onready var Sprite = get_node("Sprite")

func _ready():
	set_fixed_process(true)
	set_process_input(true)

func _input(event):
	if event.type == InputEvent.KEY && !event.is_echo():
		if event.is_action_pressed("reset"):
				get_tree().reload_current_scene()

func _fixed_process(delta):
	var debug_text = ""
	rotation = get_rot()
	
	# Rotate
	if Input.is_action_pressed("rotate_left"):
		set_rot(rotation + PI/75)
	elif Input.is_action_pressed("rotate_right"):
		set_rot(rotation - PI/75)

	# Thrust
	if Input.is_action_pressed("thruster"):
		thrust = rotate_by_radians(thrust, rotation)
	else:
		thrust = Vector2(0, 0)
	
#	add_force(Vector2(), thrust)
#	apply_impulse(Vector2(), thrust)
	
	# Rotate ship to match direction
	if direction != Vector2():
		var target_angle = atan2(direction.x, direction.y) - PI
		set_rot(target_angle)
		
	# DEBUG
	debug_text += "direction: " + str(direction) + "\n"
	debug_text += "thrust: " + str(thrust) + "\n"
	debug_text += "rotation: " + str(rotation) + "\n"
	# debug_text += "drag: " + str(drag) + "\n"
	# debug_text += "forces: " + str(forces) + "\n"
	# debug_text += "----------------------\n"
	# debug_text += "velocity: " + str(velocity) + "\n"
	# debug_text += "position: " + str(position) + "\n"

	DebugLabel.set_text(debug_text)

func rotate_by_radians(vector, radians):
	var ca = cos(radians)
	var sa = sin(radians)
	return Vector2(ca * vector.x - sa * vector.y, sa * vector.x + ca * vector.y)