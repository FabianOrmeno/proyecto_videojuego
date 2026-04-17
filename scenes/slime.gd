extends CharacterBody2D

@export var speed = 500
@export var acceleration = 3000
@export var max_health = 10
@export var health = 10

@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var ray_cast_en: RayCast2D = $pivot/RayCastEn
@onready var ray_cast_floor: RayCast2D = $pivot/RayCastFloor
@onready var pivot: Node2D = $pivot
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]
@onready var damage_stream_player: AudioStreamPlayer = $DamageStreamPlayer

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
		
	var move_input = sign(pivot.scale.x)
	
	if is_on_floor():
		if abs(velocity.x) > 10 or move_input:
			playback.travel("run")
		else:
			playback.travel("idle")
	else:
		playback.travel("idle")

	
	velocity.x = move_toward(velocity.x, move_input * speed, acceleration * delta)
	if is_on_floor() and (not ray_cast_floor.is_colliding()):
		pivot.scale.x *= -1
	
	move_and_slide()
	
func take_damage(value: int) -> void:
	Debug.log("%s received %d damage" % [name, value])
	damage_stream_player.play()
	health -= value
	if health <= 0:
		set_physics_process(false)
		hitbox_component.hide()
		hurtbox_component.hide()
		Debug.log("me morici :(")
		playback.travel("death")
