extends Camera2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	set_process_input(true)

func _input(event):
	if Input.is_action_pressed("zoom_out"):
		set_zoom(get_zoom() * 1.25)

	if Input.is_action_pressed("zoom_in"):
		set_zoom(get_zoom() * 0.75)

	