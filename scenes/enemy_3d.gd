extends CharacterBody3D

@export var speed = 1
@export var stun_time = 0.5
@export var catch_distance = 3.0
@export var chase_distance = 15.0
@export var player : CharacterBody3D

@onready var animation_player: AnimationPlayer = $Character_Monster_04/AnimationPlayer

@onready var light_hurt_component: Area3D = $LightHurtComponent

var stun_timer = 0.0

func _ready():
	animation_player.play("enemy_animaciones/walk")

func _physics_process(delta: float) -> void:
	if player == null:
		return
	
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
		
	if not can_chase_player():
			velocity.x = 0
			velocity.z = 0
			move_and_slide()
			return
	
	var is_being_hit_by_light = is_in_light()
	
	if is_being_hit_by_light:
		stun_timer = stun_time
		velocity.x = 0
		velocity.z = 0
		move_and_slide()
		animation_player.speed_scale = 0
		
		return
	
	if stun_timer > 0:
		stun_timer -= delta
		velocity.x = 0
		velocity.z = 0
		move_and_slide()
		return
	else:
		animation_player.speed_scale = 1
	
	var direction = player.global_position - global_position
	direction.y = 0
	direction = direction.normalized()
	
	
	rotation.y = atan2(direction.x, direction.z) 
	
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	
	move_and_slide()
	animation_player.speed_scale=velocity.length()/2
	if global_position.distance_to(player.global_position) <= catch_distance:
		animation_player.play("enemy_animaciones/jumpscare")
		await animation_player.animation_finished
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func can_chase_player() -> bool:
	if global_position.distance_to(player.global_position) <= chase_distance:
		return true
	
	return false

func is_in_light() -> bool:
	for area in light_hurt_component.get_overlapping_areas():
		if area.name == "LightHitComponent" and area.visible:
			return true
	
	return false
