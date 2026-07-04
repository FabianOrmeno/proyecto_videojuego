extends Node3D

@onready var area_light_3d: AreaLight3D = $AreaLight3D
@onready var fire_exit: MeshInstance3D = $FireExit

var on = true
var cooldown = false

func _physics_process(delta: float) -> void:
	if cooldown:
		return
	var azar = randi()%100
	if azar == 0 and on:
		on = false
		Debug.log("APAGANDO LA LUZ")
		area_light_3d.hide()
		fire_exit.get("surface_material_override/0").albedo_color = Color(1.0, 1.0, 1.0, 1.0)
		start_cooldown()
	if azar >= 50 and not on:
		on = true
		Debug.log("PRENDIENDO LA LUZ")
		area_light_3d.show()
		fire_exit.get("surface_material_override/0").albedo_color = Color(18.892, 18.892, 18.892, 1.0)
	return

func start_cooldown():
	cooldown = true
	await get_tree().create_timer(0.3).timeout
	cooldown = false
