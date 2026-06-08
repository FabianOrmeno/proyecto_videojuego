extends CharacterBody3D

@export var speed = 1
@export var stun_time = 0.5
@export var catch_distance = 2.0
@export var chase_distance = 15.0
@export var player : CharacterBody3D
@export var game_over_screen: GameOverScreen
@export var jumpscare_delay = 2

@onready var animation_player: AnimationPlayer = $Character_Monster_04/AnimationPlayer
@onready var light_hurt_component: Area3D = $LightHurtComponent

var stun_timer = 0.0
var player_caught = false

func _ready():
	animation_player.play("enemy_animaciones/walk")

func _physics_process(delta: float) -> void:
	if player_caught:
		return
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
		catch_player()

func catch_player() -> void:
	if player_caught:
		return
	player_caught = true
	
	velocity.x = 0
	velocity.z = 0
	
	if game_over_screen != null:
		game_over_screen.request_game_over()
	
	if player.has_method("lose_control"):
		player.lose_control()
	
	animation_player.play("enemy_animaciones/jumpscare")
	
	await get_tree().create_timer(jumpscare_delay).timeout
	
	if game_over_screen != null:
		game_over_screen.start_game_over()
	else:
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
