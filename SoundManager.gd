extends Node

onready var SamplePlayer = get_node("SamplePlayer")

var thrustIsPlaying = false
var thrustVoiceId = null

func _ready():
	SamplePlayer.set_default_volume(0.4)
	set_process(true)
	Globals.set("triggerThrustSound", false)
	Globals.set("triggerLaserSound", false)

func _process(delta):
	
	if Globals.get("triggerLaserSound"):
		var random_pitch = rand_range(0.75, 1.25)
		SamplePlayer.set_default_pitch_scale(random_pitch)
		SamplePlayer.play("laser")
		SamplePlayer.set_default_pitch_scale(1.0)
		Globals.set("triggerLaserSound", false)
	
	# Thruster
	if Globals.get("triggerThrustSound"):
		if !thrustIsPlaying:
			thrustVoiceId = SamplePlayer.play("thrusters")
			thrustIsPlaying = true
		Globals.set("triggerThrustSound", false)
	else:
		if thrustIsPlaying:
			thrustIsPlaying = false
			SamplePlayer.stop(thrustVoiceId)