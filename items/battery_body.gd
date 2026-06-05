extends Node3D

@onready var cylinder: MeshInstance3D = $Cylinder

func activate_outline():
	cylinder.get("surface_material_override/0").stencil_mode = BaseMaterial3D.STENCIL_MODE_OUTLINE
	cylinder.get("surface_material_override/1").stencil_mode = BaseMaterial3D.STENCIL_MODE_OUTLINE
	cylinder.get("surface_material_override/2").stencil_mode = BaseMaterial3D.STENCIL_MODE_OUTLINE

func deactivate_outline():
	cylinder.get("surface_material_override/0").stencil_mode = BaseMaterial3D.STENCIL_MODE_DISABLED
	cylinder.get("surface_material_override/1").stencil_mode = BaseMaterial3D.STENCIL_MODE_DISABLED
	cylinder.get("surface_material_override/2").stencil_mode = BaseMaterial3D.STENCIL_MODE_DISABLED
