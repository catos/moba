extends KinematicBody2D

var direction = Vector2(0, -1)
var direction2 = Vector2(0, -1)
var motion = Vector2()
var thrust = Vector2()

var gravity = Vector2()
var speed = 0
var acceleration = 5
var deceleration = 1
var target_angle = 0
var MAX_SPEED = 200

onready var DebugLabel = get_node("/root/Game/DebugLabel")
onready var Sprite = get_node("Sprite")
onready var Player = get_node("/root/Game/SamplePlayer")

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	var debug_text = ""
	
	if Input.is_action_pressed("rotate_left"):
		direction = rotate_by_radians(direction, -PI/50).normalized()
	elif Input.is_action_pressed("rotate_right"):
		direction = rotate_by_radians(direction, PI/50).normalized()

	speed = clamp(speed, 0, MAX_SPEED)
	if Input.is_action_pressed("thruster"):
#		Player.play("EQUIPMENT Cloth Ruffle 03")
		direction2 = direction
		speed += acceleration
		thrust = speed * direction2 * delta
	else:
		speed -= deceleration
		thrust = speed * direction2 * delta
	
	
	gravity.y += 1 * delta
	gravity.y = clamp(gravity.y, 0, 2)
	motion = thrust + gravity
	move(motion)

	if direction != Vector2():
		target_angle = atan2(direction.x, direction.y) - PI
		Sprite.set_rot(target_angle)
		
	# DEBUG
	debug_text += "direction: " + str(direction) + "\n"
	debug_text += "motion: " + str(motion) + "\n"
	debug_text += "thrust: " + str(thrust) + "\n"
	debug_text += "--\n"
	debug_text += "gravity: " + str(gravity) + "\n"
	debug_text += "target_angle: " + str(target_angle) + "\n"
	debug_text += "speed: " + str(speed) + "\n"

	DebugLabel.set_text(debug_text)

func rotate_by_radians(vector, radians):
	var ca = cos(radians)
	var sa = sin(radians)
	return Vector2(ca * vector.x - sa * vector.y, sa * vector.x + ca * vector.y)