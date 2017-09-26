extends KinematicBody2D

var velocity = Vector2()
onready var timer = get_node("Timer")

func setup(_position, _ship_velocity, _velocity, _angle):
	velocity = Vector2(0, -200)
	set_pos(_position)
#	set_rot(_angle)

func _ready():
	timer.set_wait_time(1)
	timer.connect("timeout", self, "_on_timer_timeout") 
	timer.start()
	set_process(true)
	
func _process(delta):
	translate(velocity * delta)
	
func _on_timer_timeout():
	queue_free()