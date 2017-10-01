extends KinematicBody2D

var velocity = Vector2()
export var speed = 1000

func _ready():
	get_node("Lifetime").start()
	set_fixed_process(true)
	
func setup(_position, _rotation):
	set_rot(_rotation)
	set_pos(_position)
	velocity = Vector2(speed, 0).rotated(_rotation + PI/2)

func _fixed_process(delta):
#	translate(velocity * delta)
	set_pos(get_pos() + velocity * delta)

func _on_Lifetime_timeout():
	queue_free()

