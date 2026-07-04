class_name ActivatebleBody

extends StaticBody3D
var start_rotation
var tween
@export var open_sfx: AudioStream
@export var close_sfx: AudioStream

func _ready() -> void:
	start_rotation = rotation_degrees.y

func activate():
	if tween:
		tween.kill() # Abort the previous animation.
	tween = create_tween()
	tween.tween_property(self, "rotation_degrees:y", start_rotation - 90.0, 0.5)
	Debug.log("Activate")
	AudioManager.play_sfx(open_sfx)
	
func deactivate():
	if tween:
		tween.kill() # Abort the previous animation.
	tween = create_tween()
	tween.tween_property(self, "rotation_degrees:y", start_rotation, 0.5)
	Debug.log("Deactivate")
	AudioManager.play_sfx(close_sfx)
	
