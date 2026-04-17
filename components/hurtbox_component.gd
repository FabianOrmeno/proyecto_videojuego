class_name HurtboxComponent
extends Area2D

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	visibility_changed.connect(_on_visibility_changed)

func _on_area_entered(area: Area2D) -> void:
	var hitbox = area as HitboxComponent
	if hitbox and hitbox.visible and visible:
		Debug.log("damage received")
		if owner.has_method("take_damage"):
			owner.take_damage(hitbox.damage)
			hitbox.damage_dealt.emit()
			
func _on_visibility_changed():
	set_deferred("monitorable", visible)
	set_deferred("monitoring", visible)
