extends CharacterBody3D

@export var speed = 30
@export var acceleration = 300
@onready var pivot: Node3D = $pivot

var mouse_sensitivity = 0.01
@export var tilt_limit = deg_to_rad(75)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		pivot.rotation.x -= event.screen_relative.y * mouse_sensitivity
		pivot.rotation.x = clampf(pivot.rotation.x, -tilt_limit, tilt_limit)
		pivot.rotation.y += -event.screen_relative.x * mouse_sensitivity

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
		
	var move_input = Input.get_vector("move_left", "move_right", "move_front", "move_back")
	velocity.x = move_toward(velocity.x, move_input.x * speed, acceleration * delta)
	velocity.z = move_toward(velocity.z, move_input.y * speed, acceleration * delta)
	Debug.log(Input.is_action_pressed("move_left"))
	move_and_slide()
