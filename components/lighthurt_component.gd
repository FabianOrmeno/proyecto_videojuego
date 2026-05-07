class_name LightHurtComponent
extends Area3D

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	visibility_changed.connect(_on_visibility_changed)

func _on_area_entered(area: Area3D) -> void:
	var hitbox = area as LightHitComponent
	if hitbox:
		Debug.log("Entered light")
		if owner.has_method("entered_light"):
			owner.entered_light()
			
func _on_area_exited(area: Area3D) -> void:
	var hitbox = area as LightHitComponent
	if hitbox:
		Debug.log("Exited light")
		if owner.has_method("exited_light"):
			owner.extited_light()

			
func _on_visibility_changed():
	set_deferred("monitorable", visible)
	set_deferred("monitoring", visible)
