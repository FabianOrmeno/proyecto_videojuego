extends Items

func _ready() -> void:
	mesh_instance_3d = $MeshInstance3D
	super._ready()

func pick_up(player: Player3D):
	player.add_light()
	queue_free()
