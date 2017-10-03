extends Node

const DEFAULT_VOLUME = 0.5

onready var player = get_node("SamplePlayer")

var thrustIsPlaying = false
var thrustVoiceId = null

func _ready():
	player.set_default_volume(DEFAULT_VOLUME)
	set_process(true)
	Globals.set("triggerThrustSound", false)
	Globals.set("triggerLaserSound", false)

func _process(delta):
	
	if Globals.get("triggerLaserSound"):
		var random_pitch = rand_range(0.75, 1.25)
		player.set_default_pitch_scale(random_pitch)
		player.play("laser")
		player.set_default_pitch_scale(1.0)
		Globals.set("triggerLaserSound", false)
	
	# Thruster
	if Globals.get("triggerThrustSound"):
		if !thrustIsPlaying:
			thrustVoiceId = player.play("thrusters")
			thrustIsPlaying = true
		Globals.set("triggerThrustSound", false)
	else:
		if thrustIsPlaying:
			thrustIsPlaying = false
			player.stop(thrustVoiceId)