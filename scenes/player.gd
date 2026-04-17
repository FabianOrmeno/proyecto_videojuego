extends CharacterBody2D
class_name Player

@export var speed = 500
@export var jump_speed = 400
@export var acceleration = 3000
@export var camera_acceleration = 10
@export var camera_speed = 200

var _was_on_floor: bool = false

@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var pivot: Node2D = $pivot
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]
@onready var camera_2d: Camera2D = $Camera2D
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var jump_timer: Timer = $JumpTimer
@onready var jump_stream_player: AudioStreamPlayer = $JumpStreamPlayer
@onready var damage_stream_player: AudioStreamPlayer = $DamageStreamPlayer


var max_health = 40
var health = 40
var camera_offset = 0


func _ready() -> void:
	hitbox_component.damage_dealt.connect(_on_damage_dealt)
	hitbox_component.hide()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		hitbox_component.show()
		velocity.y += get_gravity().y * delta
		
	if not is_on_floor() and _was_on_floor:
		coyote_timer.start()
		
	if (is_on_floor() or not coyote_timer.is_stopped()) and Input.is_action_just_pressed("jump") and jump_timer.is_stopped():
		jump_timer.start()
		jump_stream_player.play()
		Debug.log("saltando :)")
	if Input.is_action_just_released("jump"):
		jump_timer.stop()
		coyote_timer.stop()
	if not jump_timer.is_stopped():
		velocity.y = -jump_speed
	
	var move_input = Input.get_axis("move_left", "move_right")
	velocity.x = move_toward(velocity.x, move_input * speed, acceleration * delta)
	
	if is_on_floor():
		hitbox_component.hide()
		if abs(velocity.x) > 10 or move_input:
			if (abs(velocity.x) == speed):
				playback.travel("run")
			else:
				playback.travel("walk")
		else:
			playback.travel("idle")
	else:
		if velocity.y < 0:
			playback.travel("jump")
		else:
			playback.travel("fall")
	var towards = 0
	var actual_camera_speed = camera_speed
	if abs(velocity.x) > 0:
		towards = move_input * 200
	if sign(camera_offset) != move_input:
		actual_camera_speed *= 1 + (abs(towards)/200)**2 
	camera_offset = move_toward(camera_offset, towards, actual_camera_speed * delta)
	camera_2d.position.x=camera_offset
	
	_was_on_floor = is_on_floor()
	
	move_and_slide()
	
	if move_input:
		pivot.scale.x = sign(move_input)
		
func take_damage(value: int) -> void:
	Debug.log("%s received %d damage" % [name, value])
	damage_stream_player.play()
	health -= value
	if health <= 0:
		hitbox_component.hide()
		hurtbox_component.hide()
		set_physics_process(false)
		playback.travel("death")
		Debug.log("me moriii :C")
	else:
		var damage_dir = sign(pivot.scale.x)*-1
		velocity.y = -1*jump_speed/2
		velocity.x = damage_dir*700
		hurtbox_component.hide()
		pivot.modulate = Color(3,3,3,1)
		_was_on_floor=false
		await get_tree().create_timer(1).timeout
		pivot.modulate = Color(1,1,1,1)
		hurtbox_component.show()

func _on_damage_dealt() -> void:
	velocity.y = -jump_speed*1.25
	Debug.log("I made damage")
