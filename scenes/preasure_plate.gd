extends Area3D

var on_plate: int = 0
@export var door: ActivatebleBody

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	on_plate = 0
	
func _on_body_entered(body: CharacterBody3D) -> void:
	var char = body as Player3D
	if not char:
		char = body as Enemy3D
	if char:
		on_plate += 1
		if door:
			door.activate()

			
func _on_body_exited(body: CharacterBody3D) -> void:
	var char = body as Player3D
	if not char:
		char = body as Enemy3D
	if char:
		on_plate -= 1
		if on_plate == 0:
			if door:
				door.deactivate()
