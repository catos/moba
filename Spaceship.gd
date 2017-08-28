extends KinematicBody2D

var direction = Vector2(0, -1)

var thrust = Vector2()
var gravity = Vector2(0, 1)
var drag = Vector2()
var forces = Vector2()

var velocity = Vector2()
var position = Vector2()


var thruster_power = 150
const DAMP = 1

onready var DebugLabel = get_node("/root/Game/DebugLabel")
onready var Sprite = get_node("Sprite")
# onready var Player = get_node("/root/Game/SamplePlayer")

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	var debug_text = ""
	
	if Input.is_action_pressed("rotate_left"):
		direction = rotate_by_radians(direction, -PI/90).normalized()
	elif Input.is_action_pressed("rotate_right"):
		direction = rotate_by_radians(direction, PI/90).normalized()

	if Input.is_action_pressed("thruster"):
#		Player.play("EQUIPMENT Cloth Ruffle 03")		
		thrust = thruster_power * direction * delta
	else:
		thrust = Vector2(0, 0)
	
	# Drag
	drag = -DAMP * velocity

	# Sum forces
	forces = thrust + gravity + drag

	velocity += forces * delta
	position += velocity * delta
	move(position)

	# Rotate ship to match direction
	if direction != Vector2():
		var target_angle = atan2(direction.x, direction.y) - PI
		Sprite.set_rot(target_angle)
		
	# DEBUG
	debug_text += "direction: " + str(direction) + "\n"

	debug_text += "thrust: " + str(thrust) + "\n"
	debug_text += "gravity: " + str(gravity) + "\n"
	debug_text += "drag: " + str(drag) + "\n"
	debug_text += "forces: " + str(forces) + "\n"
	debug_text += "----------------------\n"
	debug_text += "velocity: " + str(velocity) + "\n"
	debug_text += "position: " + str(position) + "\n"

	DebugLabel.set_text(debug_text)

func rotate_by_radians(vector, radians):
	var ca = cos(radians)
	var sa = sin(radians)
	return Vector2(ca * vector.x - sa * vector.y, sa * vector.x + ca * vector.y)