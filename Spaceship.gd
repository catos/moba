extends KinematicBody2D

var direction = Vector2(-1, 0)
var rotation = PI/2

onready var DebugLabel = get_node("/root/Game/DebugLabel")

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	var debug_text = ""
	
	if Input.is_action_pressed("rotate_left"):
		# direction -= rotate_by_radians(direction, -PI/10)
		rotation += 2 * delta
	elif Input.is_action_pressed("rotate_right"):
		# direction += rotate_by_radians(direction, PI/10)
		rotation -= 2 * delta
	else:
		rotation = get_rot()
	
	if abs(rotation) > PI * 2:
		rotation = 0

	set_rot(rotation)

	# DEBUG
	debug_text += "rotation: " + str(rotation) + "\n"
	DebugLabel.set_text(debug_text)

func rotate_by_radians(vector, radians):
	var ca = cos(radians)
	var sa = sin(radians)
	return Vector2(ca * vector.x - sa * vector.y, sa * vector.x + ca * vector.y)