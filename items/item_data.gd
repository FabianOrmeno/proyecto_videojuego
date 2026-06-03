class_name Items
extends StaticBody3D

var mesh_instance_3d

func _ready() -> void:
	mesh_instance_3d.get("surface_material_override/0").stencil_mode = BaseMaterial3D.STENCIL_MODE_DISABLED

func entered_light():
	mesh_instance_3d.get("surface_material_override/0").stencil_mode = BaseMaterial3D.STENCIL_MODE_OUTLINE
	return
	
func exited_light():
	mesh_instance_3d.get("surface_material_override/0").stencil_mode = BaseMaterial3D.STENCIL_MODE_DISABLED
	return
	
func pick_up(player: Player3D):
	queue_free()
