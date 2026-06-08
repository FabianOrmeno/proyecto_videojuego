class_name Player3D
extends CharacterBody3D

@export var game_music: AudioStream
@export var no_battery_music: AudioStream

@export var batteryLife = 1000
@export var speed = 2
@export var acceleration = 3
@export var item = preload("res://scenes/standing_light.tscn")

@onready var pivot: Node3D = $pivot
@onready var ray_cast_3d: RayCast3D = $pivot/SpringArm3D/Camera3D/RayCast3D
@onready var node: Node = $Node

@onready var light_hit_component: LightHitComponent = $pivot/LightHitComponent
@onready var spot_light_3d: SpotLight3D = $pivot/SpotLight3D
@onready var progress_bar: ProgressBar = $CanvasLayer/Panel/ProgressBar
@onready var batteries: Label = $CanvasLayer/Control/Batteries
@onready var lights: Label = $CanvasLayer/Control/Lights

var mouse_sensitivity = 0.005
@export var tilt_limit = deg_to_rad(75)

var no_battery_music_started = false
var battery_amount = 2
var light_amount = 2

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	light_hit_component.hide()
	spot_light_3d.hide()
	progress_bar.max_value = batteryLife
	progress_bar.value = batteryLife
	
	if game_music != null:
		AudioManager.play_music(game_music)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		pivot.rotation.x -= event.screen_relative.y * mouse_sensitivity
		pivot.rotation.x = clampf(pivot.rotation.x, -tilt_limit, tilt_limit)
		pivot.rotation.y += -event.screen_relative.x * mouse_sensitivity

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
	
	var direction = Vector3.ZERO
	
	if Input.is_action_pressed("move_front"):
		direction -= pivot.transform.basis.z
	if Input.is_action_pressed("move_back"):
		direction += pivot.transform.basis.z
	if Input.is_action_pressed("move_right"):
		direction += pivot.transform.basis.x
	if Input.is_action_pressed("move_left"):
		direction -= pivot.transform.basis.x
	
	if Input.is_action_just_pressed("click") and batteryLife > 0:
		spot_light_3d.visible = !spot_light_3d.visible
		light_hit_component.visible = !light_hit_component.visible
	
	if Input.is_action_just_pressed("reload") and battery_amount > 0:
		batteryLife = 1000
		battery_amount -= 1
		no_battery_music_started = false
		
		progress_bar.value = batteryLife
		batteries.text = "Batteries: " + str(battery_amount)
		
		if game_music != null:
			AudioManager.play_music(game_music)
	
	if Input.is_action_just_pressed("use") and light_amount > 0:
		if ray_cast_3d.is_colliding() and is_instance_of(ray_cast_3d.get_collider(), StaticBody3D):
			var new_position = ray_cast_3d.get_collision_point()
			if global_position.distance_to(new_position) < 4:
				var new_item = item.instantiate()
				node.add_child(new_item)
				new_item.global_position = new_position
				new_item.global_position.y += 0.3
				new_item.global_rotation = Vector3(0, pivot.global_rotation.y, 0)
				light_amount -= 1
				lights.text = "Lights: " + str(light_amount)
	
	if Input.is_action_just_pressed("interact"):
		if ray_cast_3d.is_colliding() and is_instance_of(ray_cast_3d.get_collider(), Items):
			ray_cast_3d.get_collider().pick_up(self)
	
	if spot_light_3d.visible:
		batteryLife -= 1
		progress_bar.value = batteryLife
	
	if batteryLife <= 0 and spot_light_3d.visible:
		batteryLife = 0
		progress_bar.value = batteryLife
		
		spot_light_3d.hide()
		light_hit_component.hide()
		
		if not no_battery_music_started:
			no_battery_music_started = true
			
			if no_battery_music != null:
				AudioManager.play_music(no_battery_music)
	
	direction = direction.normalized()
	
	velocity.x = direction.x * speed 
	velocity.z = direction.z * speed
	
	move_and_slide()

func add_battery():
	battery_amount += 1
	batteries.text = "Batteries: " + str(battery_amount)

func add_light():
	light_amount += 1
	lights.text = "Lights: " + str(light_amount)
