class_name Items
extends StaticBody3D

var body

func _ready() -> void:
	body.deactivate_outline()

func entered_light():
	body.activate_outline()
	return
	
func exited_light():
	body.deactivate_outline()
	return
	
func pick_up(player: Player3D):
	queue_free()
