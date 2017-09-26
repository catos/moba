extends RigidBody2D

export var thruster_power = 350
export var torque = 2000
export var max_speed = 300

var fuel = 100
var can_rotate = true
var thrust = Vector2(0, -thruster_power)

var position = Vector2()
var angle_to_mouse

onready var Game = get_node("/root/Game")
onready var DebugLabel = get_node("/root/Game/UI/DebugLabel")
onready var Sprite = get_node("Sprite")

const scn_laser = preload("res://Laser.tscn")

# Timer
onready var WeaponTimer = get_node("WeaponTimer")
var weapon_delay = 0.25
var can_shoot = true

func _ready():
	WeaponTimer.set_one_shot(true)
	WeaponTimer.set_wait_time(weapon_delay)
	WeaponTimer.connect("timeout", self, "on_weapon_timeout")
	
	set_fixed_process(true)
	set_process_input(true)

func on_weapon_timeout():
	can_shoot = true

func _input(event):
	if Input.is_action_pressed("reset"):
			get_tree().reload_current_scene()
	
	if Input.is_action_pressed("shoot") && can_shoot:
		shoot(Vector2())
		can_shoot = false
		WeaponTimer.start()

func _integrate_forces(state):
	var debug_text = ""
		
	# Thrust
	if Input.is_action_pressed("thruster"):
		fuel -= 0.025
		if fuel > 0:
			set_applied_force(state.get_total_gravity() + thrust.rotated(get_rot()))
	else:
		set_applied_force(state.get_total_gravity() + Vector2())
	
	# Rotate
	var t = Input.is_action_pressed("rotate_right") - Input.is_action_pressed("rotate_left")
	set_applied_torque(torque * t)

	# Max velocity
	if abs(get_linear_velocity().x) > max_speed or abs(get_linear_velocity().y) > max_speed:
		var new_speed = get_linear_velocity().normalized() * max_speed
		set_linear_velocity(new_speed)
		

	# DEBUG
	debug_text += "fuel: " + str(fuel) + "\n"
	debug_text += "can_rotate: " + str(can_rotate) + "\n"
	debug_text += "velocity: " + str(get_linear_velocity()) + "\n"
	debug_text += "thrust: " + str(thrust.rotated(get_rot())) + "\n"
	debug_text += "total_gravity: " + str(state.get_total_gravity()) + "\n"
	debug_text += "position: " + str(get_pos()) + "\n"
	debug_text += "can_shoot: " + str(can_shoot) + ": " + str(WeaponTimer.get_time_left()) + "\n"
	
	DebugLabel.set_text(debug_text)
	pass

func shoot(pos):
	var laser = scn_laser.instance()
	laser.setup(pos, get_linear_velocity(), get_global_mouse_pos().normalized(), get_pos().angle_to_point(get_local_mouse_pos()))
	Game.add_child(laser)
	pass