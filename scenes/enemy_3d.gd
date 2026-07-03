class_name Enemy3D
extends CharacterBody3D

@export var speed = 1
@export var stun_time = 0.5
@export var catch_distance = 2.0
@export var chase_distance = 15.0
@export var player : CharacterBody3D
@export var game_over_screen: GameOverScreen
@export var jumpscare_delay = 2
@export var lose_chase_distance = 22.0
@export var roam_radius = 4.0
@export var roam_wait_time = 1.0
@export var update_target_time = 0.25
@export var stuck_time_limit = 1.5

@onready var animation_player: AnimationPlayer = $Character_Monster_04/AnimationPlayer
@onready var light_hurt_component: Area3D = $LightHurtComponent
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

var stun_timer = 0.0
var player_caught = false
var home_position = Vector3.ZERO
var is_chasing = false
var is_returning_home = false
var roam_timer = 0.0
var update_target_timer = 0.0
var last_position = Vector3.ZERO
var stuck_timer = 0.0

func _ready():
	animation_player.play("enemy_animaciones/walk")
	home_position = global_position
	navigation_agent.path_desired_distance = 0.5
	navigation_agent.target_desired_distance = 0.8
	call_deferred("set_random_roam_target")
	last_position = global_position

func _physics_process(delta: float) -> void:
	if player_caught:
		return
	if player == null:
		return
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
	
	update_navigation_target(delta)
	
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
	
	move_with_navigation()
	
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

func update_navigation_target(delta: float) -> void:
	var distance_to_player = global_position.distance_to(player.global_position)
	
	if can_chase_player():
		is_chasing = true
		is_returning_home = false
		
		update_target_timer -= delta
		
		if update_target_timer <= 0:
			update_target_timer = update_target_time
			navigation_agent.target_position = player.global_position
		
		return
	
	if is_chasing and distance_to_player > lose_chase_distance:
		is_chasing = false
		is_returning_home = true
		navigation_agent.target_position = home_position
		return
	
	if is_chasing:
		update_target_timer -= delta
		
		if update_target_timer <= 0:
			update_target_timer = update_target_time
			navigation_agent.target_position = player.global_position
		
		return
	
	if is_returning_home:
		if global_position.distance_to(home_position) <= 1.0:
			is_returning_home = false
			set_random_roam_target()
		
		return
	
	update_roaming(delta)

func set_random_roam_target() -> void:
	roam_timer = roam_wait_time
	
	var random_x = randf_range(-roam_radius, roam_radius)
	var random_z = randf_range(-roam_radius, roam_radius)
	var random_position = home_position + Vector3(random_x, 0, random_z)
	
	var navigation_map = navigation_agent.get_navigation_map()
	var closest_position = NavigationServer3D.map_get_closest_point(navigation_map, random_position)
	
	navigation_agent.target_position = closest_position

func move_with_navigation() -> void:
	if navigation_agent.is_navigation_finished():
		velocity.x = 0
		velocity.z = 0
		move_and_slide()
		return
	
	var next_position = navigation_agent.get_next_path_position()
	var direction = next_position - global_position
	
	direction.y = 0
	direction = direction.normalized()
	
	rotation.y = atan2(direction.x, direction.z)
	
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	
	move_and_slide()
	
	animation_player.speed_scale = velocity.length() / 2

func update_roaming(delta: float) -> void:
	if navigation_agent.is_navigation_finished():
		roam_timer -= delta
		
		if roam_timer <= 0:
			set_random_roam_target()
		
		stuck_timer = 0.0
		last_position = global_position
		return
	
	if global_position.distance_to(last_position) < 0.05:
		stuck_timer += delta
	else:
		stuck_timer = 0.0
		last_position = global_position
	
	if stuck_timer >= stuck_time_limit:
		stuck_timer = 0.0
		set_random_roam_target()
