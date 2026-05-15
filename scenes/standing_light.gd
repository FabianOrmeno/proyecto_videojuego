extends RigidBody3D

@export var battery_life = 1000

func _physics_process(delta: float) -> void:
	battery_life -= 1
	if battery_life == 0:
		queue_free()
