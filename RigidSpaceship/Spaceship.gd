extends RigidBody2D

export var thruster_power = 450
export var torque = 3000
export var max_speed = 300
export var weapon_delay = 0.125
export var fuel_consumption = 0.05

var fuel = 100
var can_rotate = true
var thrust = Vector2(0, -thruster_power)

var position = Vector2()
var mouse_pos = Vector2()
var mouse_angle = 0
var debug = false

onready var movement_visualizer = get_node("MovementVisualizer")
onready var debug_label = get_node("/root/Game/UI/DebugLabel")
onready var fuel_label = get_node("/root/Game/UI/FuelLabel")

onready var thrusters = get_node("Thrusters")
onready var laser_container = get_node("LaserContainer")
onready var camera = get_node("Camera")

const scn_laser = preload("res://Laser.tscn")

# Timer
onready var WeaponTimer = get_node("WeaponTimer")
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
		shoot()
		can_shoot = false
		WeaponTimer.start()
	
	if Input.is_action_pressed("zoom_out"):
		camera.set_zoom(camera.get_zoom() * 1.25)

	if Input.is_action_pressed("zoom_in"):
		Camera.set_zoom(Camera.get_zoom() * 0.75)

	if Input.is_action_pressed("debug"):
		debug = not debug
		movement_visualizer.set("visibility/visible", debug)

func _integrate_forces(state):
	var debug_text = ""

	# Debug
#	var bodies = get_colliding_bodies()
#	if !bodies.empty():
#		print(bodies)
	
	
	mouse_pos = get_viewport().get_mouse_pos()
	mouse_angle = get_pos().angle_to_point(mouse_pos)
	
	# Thrust
	if Input.is_action_pressed("thruster"):
		if fuel > 0:
			thrusters.show()
			Globals.set("triggerThrustSound", true)
			fuel -= fuel_consumption
			set_applied_force(state.get_total_gravity() + thrust.rotated(get_rot()))
	else:
		thrusters.hide()
		set_applied_force(state.get_total_gravity() + Vector2())
	
	# Rotate
	var t = Input.is_action_pressed("rotate_right") - Input.is_action_pressed("rotate_left")
	set_applied_torque(torque * t)

	# Max velocity
	if abs(get_linear_velocity().x) > max_speed or abs(get_linear_velocity().y) > max_speed:
		var new_speed = get_linear_velocity().normalized() * max_speed
		set_linear_velocity(new_speed)

	# UI
	fuel_label.set_text("Fuel: " + str(round(fuel)) + "%")

	# DEBUG
	debug_text += "velocity: " + str(get_linear_velocity()) + "\n"
	debug_text += "thrust: " + str(thrust.rotated(get_rot())) + "\n"
	debug_text += "total_gravity: " + str(state.get_total_gravity()) + "\n"
	debug_text += "position: " + str(get_pos()) + "\n"
	debug_text += "can_shoot: " + str(can_shoot) + ": " + str(WeaponTimer.get_time_left()) + "\n"
	debug_text += "mouse_pos: " + str(mouse_pos) + "\n"
	debug_text += "mouse_angle: " + str(mouse_angle) + "\n"
	
	debug_label.set_text(debug_text)

func shoot():
	var laser = scn_laser.instance()
	laser_container.add_child(laser)
	print(get_node("LaserSpawnPoint").get_global_pos())
	laser.setup(get_node("LaserSpawnPoint").get_global_pos(), get_rot())
	Globals.set("triggerLaserSound", true)