extends KinematicBody2D

var direction = Vector2(0, -10)
var motion = Vector2()
var speed = 0
var target_angle = 0
var MAX_SPEED = 50

onready var DebugLabel = get_node("/root/Game/DebugLabel")
onready var Sprite = get_node("Sprite")

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	var debug_text = ""
	
	if Input.is_action_pressed("thruster"):
		speed += 2
	else:
		speed -= 5

	if Input.is_action_pressed("rotate_left"):
		direction = rotate_by_radians(direction, -PI/100)
	elif Input.is_action_pressed("rotate_right"):
		direction = rotate_by_radians(direction, PI/100)


	#look_at(direction)
	#set_rot(target_angle)
	speed = clamp(speed, 0, MAX_SPEED)

	motion = speed * direction.normalized() * delta
	move(motion)

	if motion != Vector2():
		target_angle = atan2(motion.x, motion.y) - PI
		Sprite.set_rot(target_angle)
		
	# DEBUG
	debug_text += "direction: " + str(direction) + "\n"
	debug_text += "motion: " + str(motion) + "\n"
	debug_text += "target_angle: " + str(target_angle) + "\n"
	debug_text += "speed: " + str(speed) + "\n"

	DebugLabel.set_text(debug_text)

func rotate_by_radians(vector, radians):
	var ca = cos(radians)
	var sa = sin(radians)
	return Vector2(ca * vector.x - sa * vector.y, sa * vector.x + ca * vector.y)