extends Items

func _ready() -> void:
	body = $Lantern
	super._ready()

func pick_up(player: Player3D):
	player.add_light()
	queue_free()
