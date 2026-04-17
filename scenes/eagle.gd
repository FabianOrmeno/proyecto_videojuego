extends StaticBody2D

@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]
@onready var damage_stream_player: AudioStreamPlayer = $DamageStreamPlayer



func take_damage(value: int) -> void:
	damage_stream_player.play()
	hitbox_component.hide()
	hurtbox_component.hide()
	playback.travel("death")
