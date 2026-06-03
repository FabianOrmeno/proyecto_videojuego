extends Node3D

@onready var cylinder: MeshInstance3D = $Cylinder
@onready var torus: MeshInstance3D = $Cylinder/Torus

func activate_outline():
	cylinder.get("surface_material_override/0").stencil_mode = BaseMaterial3D.STENCIL_MODE_OUTLINE
	torus.get("surface_material_override/0").stencil_mode = BaseMaterial3D.STENCIL_MODE_OUTLINE
	
func deactivate_outline():
	cylinder.get("surface_material_override/0").stencil_mode = BaseMaterial3D.STENCIL_MODE_DISABLED
	torus.get("surface_material_override/0").stencil_mode = BaseMaterial3D.STENCIL_MODE_DISABLED
