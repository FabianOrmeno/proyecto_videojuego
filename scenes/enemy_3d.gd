extends CharacterBody3D

@export var speed = 1
@export var stun_time = 2.0
@export var catch_distance = 2.0
@export var player : CharacterBody3D

@onready var light_hurt_component: Area3D = $LightHurtComponent

var stun_timer = 0.0


func _physics_process(delta: float) -> void:
	if player == null:
		return
	
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
	
	var is_being_hit_by_light = is_in_light()
	
	if is_being_hit_by_light:
		stun_timer = stun_time
		velocity.x = 0
		velocity.z = 0
		move_and_slide()
		return
	
	if stun_timer > 0:
		stun_timer -= delta
		velocity.x = 0
		velocity.z = 0
		move_and_slide()
		return
	
	var direction = player.global_position - global_position
	direction.y = 0
	direction = direction.normalized()
	
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	
	move_and_slide()
	
	if global_position.distance_to(player.global_position) <= catch_distance:
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func is_in_light() -> bool:
	for area in light_hurt_component.get_overlapping_areas():
		if area.name == "LightHitComponent" and area.visible:
			return true
	
	return false
