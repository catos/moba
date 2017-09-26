extends KinematicBody2D

var velocity = Vector2()

func setup(_position, _ship_velocity, _velocity, _angle):
	velocity = _ship_velocity + (_velocity * 300)
	set_pos(_position)
	set_rot(_angle)

func _ready():
	set_process(true)
	
func _process(delta):
	translate(velocity * delta)
