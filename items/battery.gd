extends Items

func _ready() -> void:
	body = $battery
	super._ready()

func pick_up(player: Player3D):
	player.add_battery()
	queue_free()
