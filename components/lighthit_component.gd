class_name LightHitComponent
extends Area3D

func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)

func _on_visibility_changed():
	set_deferred("monitorable", visible)
	set_deferred("monitoring", visible)
