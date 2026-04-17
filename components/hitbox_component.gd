class_name HitboxComponent
extends Area2D

signal damage_dealt

@export var damage: int = 10

func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)

func _on_visibility_changed():
	set_deferred("monitorable", visible)
	set_deferred("monitoring", visible)
