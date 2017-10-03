extends KinematicBody2D

var velocity = Vector2()
export var speed = 1000

onready var explosion = get_node("Explosion")
onready var sprite = get_node("Sprite")
onready var collision = get_node("CollisionShape2D")
onready var death_delay = get_node("DeathDelay")


func _ready():
	get_node("Lifetime").start()
	set_fixed_process(true)
	
func setup(_position, _rotation):
	set_rot(_rotation)
	set_pos(_position)
	velocity = Vector2(speed, 0).rotated(_rotation + PI/2)

func _fixed_process(delta):
	move(velocity * delta)
	
	if is_colliding():
		var collider = get_collider()
		if collider extends TileMap:
			print("collision with: ", collider)
			explode()

func explode():
	print("explode")
	explosion.set_emitting(true)
	sprite.hide()
	collision.set_trigger(true)
	death_delay.start()
	
func _on_Lifetime_timeout():
	queue_free()

func _on_DeathDelay_timeout():
	queue_free()
