extends RigidBody2D

export var thruster_power = 250

onready var rotation = get_rot()

var thrust = Vector2(0, -350)
var torque = 2000

var velocity = Vector2()
var total_gravity = Vector2()

onready var DebugLabel = get_node("/root/Game/DebugLabel")
onready var Sprite = get_node("Sprite")

func _ready():
	set_fixed_process(true)
	set_process_input(true)

func _input(event):
	if event.type == InputEvent.KEY && !event.is_echo():
		if event.is_action_pressed("reset"):
				get_tree().reload_current_scene()

func _integrate_forces(state):
	var debug_text = ""
	
	# Thrust
	if Input.is_action_pressed("thruster"):
		set_applied_force(state.get_total_gravity() + thrust.rotated(get_rot()))
	else:
		set_applied_force(state.get_total_gravity() + Vector2())
	
	# Rotate
	var t = Input.is_action_pressed("rotate_right") - Input.is_action_pressed("rotate_left")
	set_applied_torque(torque * t)


	# DEBUG
	velocity = get_linear_velocity()
	total_gravity = state.get_total_gravity()
	
	debug_text += "velocity: " + str(velocity) + "\n"
	debug_text += "thrust: " + str(thrust.rotated(get_rot())) + "\n"
	debug_text += "total_gravity: " + str(total_gravity) + "\n"

	DebugLabel.set_text(debug_text)